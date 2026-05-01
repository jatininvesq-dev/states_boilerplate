import 'package:shared_preferences/shared_preferences.dart';
import '../../features/counter/counter_injection.dart';
import '../../features/counter/presentation/bloc/counter_bloc.dart';

class AppInjection {
  static Future<AppBlocProviders> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize all feature BLoCs
    final counterBloc = await CounterInjection.initCounter(sharedPreferences);

    return AppBlocProviders(
      counterBloc: counterBloc,
    );
  }
}

class AppBlocProviders {
  final CounterBloc counterBloc;

  AppBlocProviders({
    required this.counterBloc,
  });
}
