abstract class StorageService {
  // void init();

  bool get hasInitialized;

  Future<bool> remove(String key);

  // Future<String?> get(String key);
  Future<String?> get(String key);

  Future<bool> set(String key, String data);

  Future<void> clear();

  Future<bool> has(String key);
}