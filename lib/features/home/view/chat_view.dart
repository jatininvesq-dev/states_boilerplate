import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:states_app/core/routes/app_page.dart';
import 'package:states_app/features/home/provider/home_provider.dart';
import 'package:states_app/features/chat/provider/chat_provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final conversations = chatProvider.conversations;
    final allUsers = homeProvider.users;
    final currentUserId = homeProvider.userProfile?.userId;

    // Filter out users who already have a conversation and the current user
    final conversationUserIds = conversations
        .map((c) => c.user?.userId)
        .where((id) => id != null)
        .toSet();
    
    final filteredUsers = allUsers.where((u) => 
      u.userId != currentUserId && !conversationUserIds.contains(u.userId)
    ).toList();

    if (chatProvider.isLoading && conversations.isEmpty && homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (conversations.isEmpty && filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No users found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                homeProvider.fetchAllUsers();
                chatProvider.loadConversations();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (conversations.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Recent Chats',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildConversationTile(
                context,
                conversations[index],
                chatProvider,
              ),
              childCount: conversations.length,
            ),
          ),
        ],
        if (filteredUsers.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'All Users',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildUserTile(context, filteredUsers[index]),
              childCount: filteredUsers.length,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    dynamic conversation,
    ChatProvider chatProvider,
  ) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.INBOX_MESSEGE,
        arguments: {
          'userId': conversation.user?.userId ?? conversation.sId,
          'userName': conversation.user?.name ?? 'Unknown',
        },
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(
              (conversation.user?.name ?? '?').isNotEmpty
                  ? (conversation.user?.name ?? '?')[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (chatProvider.isConnected)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation.user?.name ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          if (conversation.lastMessage == 'Sent an image')
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.image, size: 16, color: Colors.grey),
            ),
          if (conversation.lastMessage == 'Sent an document')
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.insert_drive_file,
                size: 16,
                color: Colors.grey,
              ),
            ),
          Expanded(
            child: Text(
              conversation.lastMessage == 'image'
                  ? 'Sent an image'
                  : conversation.lastMessage == 'document'
                  ? 'Sent an document'
                  : (conversation.lastMessage ?? 'No messages yet'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation.lastMessageAt != null
                ? _formatDate(conversation.lastMessageAt!)
                : '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (conversation.lastMessage != null &&
              (conversation.lastMessage!.startsWith('http') ||
                  conversation.lastMessage!.contains('/uploads/')))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  conversation.lastMessage!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserProfile user) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.INBOX_MESSEGE,
        arguments: {
          'userId': user.userId,
          'userName': user.name,
        },
      ),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.orangeAccent.withOpacity(0.1),
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.email,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
