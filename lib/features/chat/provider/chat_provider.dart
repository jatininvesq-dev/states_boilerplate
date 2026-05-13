import 'package:flutter/material.dart';
import '../chat_repo/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;

  List<ChatMessage> _messages = [];
  List<Conversation> _conversations = [];
  String? _selectedUserId;
  String? _currentUserId;
  bool _isLoading = false;
  String? _error;

  ChatProvider({required this.chatRepository}) {
    // Listen to incoming messages
    chatRepository.messageReceived.addListener(_onMessageReceived);
    // Listen to connection status changes
    chatRepository.isConnected.addListener(notifyListeners);
  }

  // Getters
  List<ChatMessage> get messages => _messages;
  List<Conversation> get conversations => _conversations;
  String? get selectedUserId => _selectedUserId;
  String? get currentUserId => _currentUserId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isConnected => chatRepository.connected;

  /// Initialize chat with user authentication
  Future<void> initializeChat({
    required String userId,
    required String authToken,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      _currentUserId = userId;
      notifyListeners();

      await chatRepository.initializeSocket(
        userId: userId,
        authToken: authToken,
      );

      await loadConversations();
    } catch (e) {
      _error = 'Failed to initialize chat: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load conversations list
  Future<void> loadConversations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _conversations = await chatRepository.fetchConversations();
    } catch (e) {
      _error = 'Failed to load conversations: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load chat history with specific user
  Future<void> loadChatHistory(String otherUserId) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedUserId = otherUserId;
      notifyListeners();

      _messages = await chatRepository.fetchMessageHistory(otherUserId);
      // Sort messages by timestamp (oldest first)
      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      _error = 'Failed to load chat history: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send message to specific user
  Future<void> sendMessage(String toUserId, String content) async {
    await _sendMessageInternal(
      toUserId: toUserId,
      content: content,
      type: 'text',
    );
  }

  /// Send attachment (image/document) to specific user
  Future<void> sendAttachment({
    required String toUserId,
    required String filePath,
    required String type,
    String? content,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Upload the file to the server
      final uploadData = await chatRepository.uploadFile(filePath);

      // Response contains: { fileUrl, fileName, fileType, filename }
      final fileUrl = uploadData['fileUrl'];
      final fileName = uploadData['fileName'] ?? uploadData['filename'];
      final fileType = uploadData['fileType'];

      if (fileUrl == null) {
        throw Exception('Server did not return a file URL');
      }

      // 2. Send the message via WebSocket with the returned URL
      await _sendMessageInternal(
        toUserId: toUserId,
        content:
            content ??
            (type == 'image' ? 'Sent an image' : 'Sent a document'), //
        type: type,
        fileUrl: fileUrl,
        fileType: fileType,
        fileName: fileName,
        localPath: filePath, // Pass the local path for preview
      );
    } catch (e) {
      _error = 'Failed to upload/send attachment: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _sendMessageInternal({
    required String toUserId,
    required String content,
    required String type,
    String? fileUrl,
    String? fileType,
    String? fileName,
    String? localPath, // Added localPath for preview
  }) async {
    if (content.trim().isEmpty && fileUrl == null && localPath == null) {
      _error = 'Message cannot be empty';
      notifyListeners();
      return;
    }

    final localMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: _currentUserId ?? '',
      toUserId: toUserId,
      content: content,
      type: type,
      fileUrl: localPath ?? fileUrl, // Use local path for preview if available
      fileType: fileType,
      fileName: fileName,
      createdAt: DateTime.now(),
    );

    try {
      _error = null;
      _messages.add(localMessage);
      notifyListeners();

      // Send via WebSocket
      chatRepository.sendMessage(
        toUserId: toUserId,
        content: content,
        type: type,
        fileUrl: fileUrl,
        fileType: fileType,
        fileName: fileName,
      );
    } catch (e) {
      _error = 'Failed to send message: $e';
      _messages.removeWhere((msg) => msg.id == localMessage.id);
      debugPrint(_error);
      notifyListeners();
    }
  }

  /// Handle incoming message from WebSocket
  void _onMessageReceived() {
    final message = chatRepository.messageReceived.value;
    if (message != null) {
      // Always update conversations list when any message arrives
      loadConversations();

      // Only add to messages list if it belongs to the currently open chat
      if (_selectedUserId != null &&
          (message.fromUserId == _selectedUserId ||
              message.toUserId == _selectedUserId)) {
        // If the message is from me, it might be a confirmation of a local 'temp_' message
        if (message.fromUserId == _currentUserId) {
          final tempIndex = _messages.indexWhere(
            (m) => m.id.startsWith('temp_') && m.content == message.content,
          );

          if (tempIndex != -1) {
            // Replace the temporary local message with the official one from the server
            _messages[tempIndex] = message;
            notifyListeners();
            return;
          }
        }

        // Add if not already in the list (prevents duplicates)
        if (!_messages.any((m) => m.id == message.id)) {
          _messages.add(message);
          notifyListeners();
        }
      }
    }
  }

  /// Delete a single message
  Future<void> deleteMessage(String messageId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await chatRepository.deleteMessage(messageId);
      if (success) {
        _messages.removeWhere((m) => m.id == messageId);
        // Also update conversations to reflect the potential change in last message
        await loadConversations();
      } else {
        _error = 'Failed to delete message';
      }
    } catch (e) {
      _error = 'Error deleting message: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear entire conversation
  Future<void> clearConversation(String otherUserId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await chatRepository.clearConversation(otherUserId);
      if (success) {
        _messages = [];
        // Also update conversations list
        await loadConversations();
      } else {
        _error = 'Failed to clear conversation';
      }
    } catch (e) {
      _error = 'Error clearing conversation: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Disconnect chat
  void disconnect() {
    chatRepository.disconnect();
    _messages = [];
    _conversations = [];
    _selectedUserId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    chatRepository.messageReceived.removeListener(_onMessageReceived);
    chatRepository.isConnected.removeListener(notifyListeners);
    disconnect();
    super.dispose();
  }
}
