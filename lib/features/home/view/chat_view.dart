import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:states_app/core/routes/app_page.dart';
import 'package:states_app/features/home/provider/home_provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    if (homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (homeProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${homeProvider.errorMessage}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => homeProvider.fetchAllUsers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final users = homeProvider.users;
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.INBOX_MESSEGE,
            arguments: {
              'userId': user.userId,
              'userName': user.name,
            },
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            ),
          ),
          title: Text(user.name.isNotEmpty ? user.name : 'Unknown'),
          subtitle: Text(user.email.isNotEmpty ? user.email : 'No email'),
          trailing: Text(_formatDate(user.createdAt)),
        );
      },
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
