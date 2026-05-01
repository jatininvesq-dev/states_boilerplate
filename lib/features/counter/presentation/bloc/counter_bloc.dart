import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/decrement_counter_usecase.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';
import '../../domain/usecases/reset_counter_usecase.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounterUseCase getCounterUseCase;
  final IncrementCounterUseCase incrementCounterUseCase;
  final DecrementCounterUseCase decrementCounterUseCase;
  final ResetCounterUseCase resetCounterUseCase;

  CounterBloc({
    required this.getCounterUseCase,
    required this.incrementCounterUseCase,
    required this.decrementCounterUseCase,
    required this.resetCounterUseCase,
  }) : super(const CounterInitial()) {
    on<GetCounterEvent>(_onGetCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<DecrementCounterEvent>(_onDecrementCounter);
    on<ResetCounterEvent>(_onResetCounter);
  }

  Future<void> _onGetCounter(
    GetCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterLoading());
    final result = await getCounterUseCase();
    result.fold(
      (exception) => emit(CounterError(message: exception.toString())),
      (counter) => emit(CounterLoaded(value: counter.value)),
    );
  }

  Future<void> _onIncrementCounter(
    IncrementCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterLoading());
    final result = await incrementCounterUseCase();
    result.fold(
      (exception) => emit(CounterError(message: exception.toString())),
      (counter) => emit(CounterLoaded(value: counter.value)),
    );
  }

  Future<void> _onDecrementCounter(
    DecrementCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterLoading());
    final result = await decrementCounterUseCase();
    result.fold(
      (exception) => emit(CounterError(message: exception.toString())),
      (counter) => emit(CounterLoaded(value: counter.value)),
    );
  }

  Future<void> _onResetCounter(
    ResetCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterLoading());
    final result = await resetCounterUseCase();
    result.fold(
      (exception) => emit(CounterError(message: exception.toString())),
      (counter) => emit(CounterLoaded(value: counter.value)),
    );
  }
}
