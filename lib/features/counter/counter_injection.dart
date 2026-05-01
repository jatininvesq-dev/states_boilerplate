import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/counter_local_datasource.dart';
import 'data/repositories/counter_repository_impl.dart';
import 'domain/repositories/counter_repository.dart';
import 'domain/usecases/decrement_counter_usecase.dart';
import 'domain/usecases/get_counter_usecase.dart';
import 'domain/usecases/increment_counter_usecase.dart';
import 'domain/usecases/reset_counter_usecase.dart';
import 'presentation/bloc/counter_bloc.dart';

class CounterInjection {
  static Future<CounterBloc> initCounter(SharedPreferences sharedPreferences) async {
    // DataSources
    final counterLocalDataSource = CounterLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );

    // Repository
    final CounterRepository counterRepository = CounterRepositoryImpl(
      localDataSource: counterLocalDataSource,
    );

    // Use Cases
    final getCounterUseCase = GetCounterUseCase(counterRepository);
    final incrementCounterUseCase = IncrementCounterUseCase(counterRepository);
    final decrementCounterUseCase = DecrementCounterUseCase(counterRepository);
    final resetCounterUseCase = ResetCounterUseCase(counterRepository);

    // BLoC
    return CounterBloc(
      getCounterUseCase: getCounterUseCase,
      incrementCounterUseCase: incrementCounterUseCase,
      decrementCounterUseCase: decrementCounterUseCase,
      resetCounterUseCase: resetCounterUseCase,
    );
  }
}
