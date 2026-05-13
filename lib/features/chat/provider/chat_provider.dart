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
    if (content.trim().isEmpty) {
      _error = 'Message cannot be empty';
      notifyListeners();
      return;
    }

    final localMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromUserId: _currentUserId ?? '',
      toUserId: toUserId,
      content: content,
      createdAt: DateTime.now(),
    );

    try {
      _error = null;
      _messages.add(localMessage);
      notifyListeners();

      // Send via WebSocket
      chatRepository.sendMessage(toUserId: toUserId, content: content);
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
      // This ensures the sidebar/list shows the latest message
      loadConversations();

      // Only add to messages list if it belongs to the currently open chat
      if (_selectedUserId != null &&
          (message.fromUserId == _selectedUserId ||
              message.toUserId == _selectedUserId)) {
        if (!_messages.any((m) => m.id == message.id)) {
          _messages.add(message);
          notifyListeners();
        }
      }
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
