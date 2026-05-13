import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../provider/chat_provider.dart';
import '../chat_repo/chat_repository.dart';

class InboxMessegeView extends StatefulWidget {
  final String? selectedUserId;
  final String? selectedUserName;

  const InboxMessegeView({
    super.key,
    this.selectedUserId,
    this.selectedUserName,
  });

  @override
  State<InboxMessegeView> createState() => _InboxMessegeViewState();
}

class _InboxMessegeViewState extends State<InboxMessegeView> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    // Load chat history if a user is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final userId = widget.selectedUserId ?? args?['userId'];

      if (userId != null) {
        context.read<ChatProvider>().loadChatHistory(userId).then((_) {
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatProvider provider) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedUserId = widget.selectedUserId ?? args?['userId'];

    if (selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user to chat with')),
      );
      return;
    }

    final content = _messageController.text;
    if (content.trim().isEmpty) return;

    provider.sendMessage(selectedUserId, content);
    _messageController.clear();
  }

  Future<void> _pickImage(ChatProvider provider) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedUserId = widget.selectedUserId ?? args?['userId'];
    if (selectedUserId == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      provider.sendAttachment(
        toUserId: selectedUserId,
        filePath: image.path,
        type: 'image',
      );
    }
  }

  Future<void> _pickDocument(ChatProvider provider) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedUserId = widget.selectedUserId ?? args?['userId'];
    if (selectedUserId == null) return;

    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      provider.sendAttachment(
        toUserId: selectedUserId,
        filePath: result.files.single.path!,
        type: 'document',
        content: result.files.single.name,
      );
    }
  }

  void _showAttachmentOptions(BuildContext context, ChatProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Attachment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentItem(
                  context,
                  icon: Icons.image,
                  color: Colors.blue,
                  label: 'Image',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(provider);
                  },
                ),
                _buildAttachmentItem(
                  context,
                  icon: Icons.insert_drive_file,
                  color: Colors.orange,
                  label: 'Document',
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument(provider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final selectedUserId = widget.selectedUserId ?? args?['userId'];
        final selectedUserName =
            widget.selectedUserName ?? args?['userName'] ?? 'Chat';
        final messages = chatProvider.messages;
        final isLoading = chatProvider.isLoading;
        final isConnected = chatProvider.isConnected;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedUserName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isConnected ? 'Active' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: isConnected ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            centerTitle: false,
            actions: [
              IconButton(icon: const Icon(Icons.call), onPressed: () {}),
              IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear' && selectedUserId != null) {
                    _showClearChatDialog(context, chatProvider, selectedUserId);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Text('Clear Chat'),
                  ),
                ],
              ),
            ],
          ),
          body: selectedUserId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No conversation selected',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (chatProvider.error != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red.shade100,
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red[800]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                chatProvider.error!,
                                style: TextStyle(color: Colors.red[800]),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: chatProvider.clearError,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: isLoading && messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Loading messages...'),
                                ],
                              ),
                            )
                          : messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mail_outline,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No messages yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start a conversation',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                // Scroll to bottom when the last item is built
                                if (index == messages.length - 1) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => _scrollToBottom(),
                                  );
                                }
                                final message = messages[index];
                                return _buildMessageBubble(
                                  context,
                                  message,
                                  chatProvider.currentUserId,
                                  chatProvider,
                                );
                              },
                            ),
                    ),
                    _buildMessageInput(context, chatProvider),
                  ],
                ),
        );
      },
    );
  }

  void _showClearChatDialog(
    BuildContext context,
    ChatProvider provider,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
          'Are you sure you want to delete all messages in this conversation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.clearConversation(userId);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteMessageDialog(
    BuildContext context,
    ChatProvider provider,
    String messageId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteMessage(messageId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ChatMessage message,
    String? currentUserId,
    ChatProvider chatProvider,
  ) {
    final isSender = message.fromUserId == currentUserId;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress:
            isSender
                ? () =>
                    _showDeleteMessageDialog(context, chatProvider, message.id)
                : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSender ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isSender ? 16 : 0),
              bottomRight: Radius.circular(isSender ? 0 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.content == 'Sent an image' && message.fileUrl != null)
                GestureDetector(
                  onTap: () {
                    // TODO: Open full image
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: message.fileUrl!.startsWith('http')
                        ? Image.network(
                            message.fileUrl!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                _buildErrorPlaceholder(),
                          )
                        : Image.file(
                            File(message.fileUrl!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildErrorPlaceholder(),
                          ),
                  ),
                ),
              if (message.content.contains(".pdf") && message.fileUrl != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.insert_drive_file, color: Colors.orange),
                    ],
                  ),
                ),
              if (message.type == 'text')
                Text(
                  message.content,
                  style: TextStyle(
                    color: isSender ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                DateFormat('hh:mm a').format(message.createdAt),
                style: TextStyle(
                  color: isSender ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showAttachmentOptions(context, chatProvider),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(chatProvider),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: () => _sendMessage(chatProvider),
            ),
          ],
        ),
      ),
    );
  }
}
