import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:states_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:states_app/features/transactions/view/transaction_view.dart';

class App extends StatelessWidget {
  final CounterBloc counterBloc;

  const App({super.key, required this.counterBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => counterBloc)],
      child: MaterialApp(
        title: 'Flutter BLoC State Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TransactionView(),
      ),
    );
  }
}
