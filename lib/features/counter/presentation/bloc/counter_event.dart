part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

class GetCounterEvent extends CounterEvent {
  const GetCounterEvent();
}

class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}

class DecrementCounterEvent extends CounterEvent {
  const DecrementCounterEvent();
}

class ResetCounterEvent extends CounterEvent {
  const ResetCounterEvent();
}
