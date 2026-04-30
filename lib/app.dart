import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:states_app/provider/auth_provider.dart';
import 'package:states_app/view/create_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Zego App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const CreateView(),
      ),
    );
  }
}