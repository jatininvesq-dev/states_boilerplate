import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:states_app/features/home/provider/home_provider.dart';
import 'package:states_app/features/home/view/chat_view.dart';
import 'package:states_app/features/home/view/dashboard_view.dart';
import 'package:states_app/features/home/view/profile_view.dart';
import 'package:states_app/features/chat/provider/chat_provider.dart';
import 'package:states_app/core/preferences/user_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch profile data when HomeView is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HomeProvider>().fetchProfile();
      context.read<HomeProvider>().fetchAllUsers();

      // Initialize Chat with current user
      final profile = context.read<HomeProvider>().userProfile;
      if (profile != null) {
        final token = AppSession.getAccessToken();
        if (mounted) {
          context.read<ChatProvider>().initializeChat(
            userId: profile.userId,
            authToken: token,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final chatProvider = context.watch<ChatProvider>();

    final List<Widget> _pages = [
      const DashboardView(),
      const ChatView(),
      const ProfileView(),
    ];

    final List<String> _titles = ['SocialoField', 'Chat', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          if (_currentIndex == 1)
            IconButton(
              onPressed: () => chatProvider.loadConversations(),
              icon: const Icon(Icons.refresh),
            ),
          if (_currentIndex == 2)
            IconButton(
              onPressed: () => homeProvider.fetchProfile(),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
