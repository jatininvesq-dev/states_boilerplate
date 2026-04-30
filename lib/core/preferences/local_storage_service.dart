import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_app/core/preferences/storage_service.dart';

class LocalStorageService implements StorageService {
  SharedPreferences? sharedPreferences;

  // final Completer<SharedPreferences> initCompleter =
  //     Completer<SharedPreferences>();
  late final Future<SharedPreferences> initCompleter =
      SharedPreferences.getInstance();

  // @override
  // void init() {
  //   initCompleter.complete(SharedPreferences.getInstance());
  // }

  @override
  bool get hasInitialized => sharedPreferences != null;

  @override
  Future<String?> get(String key) async {
    // sharedPreferences = await initCompleter.future;
    // return sharedPreferences!.getString(key);
    SharedPreferences value = await initCompleter;

    if (value.containsKey(key)) {
      String data = value.getString(key)!;
      return data;
    }
    return '';
  }

  @override
  Future<void> clear() async {
    sharedPreferences = await initCompleter;
    await sharedPreferences!.clear();
  }

  @override
  Future<bool> has(String key) async {
    sharedPreferences = await initCompleter;
    return sharedPreferences?.containsKey(key) ?? false;
  }

  @override
  Future<bool> remove(String key) async {
    sharedPreferences = await initCompleter;
    return await sharedPreferences!.remove(key);
  }

  @override
  Future<bool> set(String key, data) async {
    sharedPreferences = await initCompleter;
    return await sharedPreferences!.setString(key, data.toString());
  }
}