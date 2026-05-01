import 'package:shared_preferences/shared_preferences.dart';
import '../models/counter_model.dart';

abstract class CounterLocalDataSource {
  Future<CounterModel> getCounter();
  Future<CounterModel> incrementCounter();
  Future<CounterModel> decrementCounter();
  Future<CounterModel> resetCounter();
}

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  static const String _counterKey = 'counter_value';
  final SharedPreferences sharedPreferences;

  CounterLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CounterModel> getCounter() async {
    final value = sharedPreferences.getInt(_counterKey) ?? 0;
    return CounterModel(value: value);
  }

  @override
  Future<CounterModel> incrementCounter() async {
    final currentValue = sharedPreferences.getInt(_counterKey) ?? 0;
    final newValue = currentValue + 1;
    await sharedPreferences.setInt(_counterKey, newValue);
    return CounterModel(value: newValue);
  }

  @override
  Future<CounterModel> decrementCounter() async {
    final currentValue = sharedPreferences.getInt(_counterKey) ?? 0;
    final newValue = currentValue - 1;
    await sharedPreferences.setInt(_counterKey, newValue);
    return CounterModel(value: newValue);
  }

  @override
  Future<CounterModel> resetCounter() async {
    await sharedPreferences.setInt(_counterKey, 0);
    return CounterModel(value: 0);
  }
}
