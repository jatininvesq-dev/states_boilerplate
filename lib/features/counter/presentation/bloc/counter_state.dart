part of 'counter_bloc.dart';

abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object?> get props => [];
}

class CounterInitial extends CounterState {
  const CounterInitial();
}

class CounterLoading extends CounterState {
  const CounterLoading();
}

class CounterLoaded extends CounterState {
  final int value;

  const CounterLoaded({required this.value});

  @override
  List<Object?> get props => [value];
}

class CounterError extends CounterState {
  final String message;

  const CounterError({required this.message});

  @override
  List<Object?> get props => [message];
}
