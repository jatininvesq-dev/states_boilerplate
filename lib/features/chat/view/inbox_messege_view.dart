import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();

    // Load chat history if a user is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final userId = widget.selectedUserId ?? args?['userId'];
      
      if (userId != null) {
        context.read<ChatProvider>().loadChatHistory(userId);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatProvider provider) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final selectedUserId = widget.selectedUserId ?? args?['userId'];
        final selectedUserName = widget.selectedUserName ?? args?['userName'] ?? 'Chat';
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
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    return _buildMessageBubble(
                                      context,
                                      message,
                                      chatProvider.currentUserId,
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

  Widget _buildMessageBubble(
    BuildContext context,
    ChatMessage message,
    String? currentUserId,
  ) {
    final isSender = message.fromUserId == currentUserId;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSender
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
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
            Text(
              message.content,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                color: isSender ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
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