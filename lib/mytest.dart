import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUpWithEmailAndPassword(String email, String password) async {
    // Implement your sign-up logic here
    print('Email: $email');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in to Your Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Your Email Address'),
              controller: emailController,
            ),
            SizedBox(height: 24),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Your Password'),
              controller: passwordController,
            ),
            SizedBox(height: 24),
            Row(
              children: <Widget>[
                Checkbox(
                  value: false, // Remember Me
                  onChanged: (_) {},
                ),
                Text('Remember Me')
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _signUpWithEmailAndPassword(emailController.text.trim(), passwordController.text);
              },
              child: Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}