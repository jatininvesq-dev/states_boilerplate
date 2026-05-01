import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';
import 'features/counter/presentation/pages/counter_page.dart';

class App extends StatelessWidget {
  final CounterBloc counterBloc;

  const App({
    super.key,
    required this.counterBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> counterBloc),
      ],
      child: MaterialApp(
        title: 'Flutter BLoC State Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CounterPage(),
      ),
    );
  }
}