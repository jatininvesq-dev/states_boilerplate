import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../widgets/counter_body.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  void initState() {
    super.initState();
    context.read<CounterBloc>().add(const GetCounterEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: const CounterBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<CounterBloc>().add(const IncrementCounterEvent()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
