import 'package:flutter/material.dart';
import 'package:states_app/core/preferences/user_preferences.dart';
import 'package:states_app/core/routes/app_page.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds and then navigate to LoginView
    Future.delayed(Duration(seconds: 2), () {
      var token = AppSession.getAccessToken();
      if (token.isNotEmpty) {
        Navigator.of(context).pushReplacementNamed(Routes.HOME);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
