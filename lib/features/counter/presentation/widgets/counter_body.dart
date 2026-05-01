import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';

class CounterBody extends StatelessWidget {
  const CounterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You have pushed the button this many times:',
          ),
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              if (state is CounterLoading) {
                return const CircularProgressIndicator();
              } else if (state is CounterLoaded) {
                return Text(
                  '${state.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              } else if (state is CounterError) {
                return Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const Text('0');
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context
                    .read<CounterBloc>()
                    .add(const DecrementCounterEvent()),
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () =>
                    context.read<CounterBloc>().add(const ResetCounterEvent()),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
