import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  bool containsKey(String key);
  Set<String> getKeys();
  String? getString(String key);
  int? getInt(String key);
  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
  List<String>? getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<void> remove(String key);
  Future<void> clear();
  Future<void> reload();
}

class SharedPreferencesStorage implements LocalStorage {
  SharedPreferencesStorage(this._storage);

  final SharedPreferences _storage;

  SharedPreferences get sharedPreferences => _storage;

  @override
  bool containsKey(String key) => _storage.containsKey(key);

  @override
  Set<String> getKeys() => _storage.getKeys();

  @override
  String? getString(String key) => _storage.getString(key);

  @override
  int? getInt(String key) => _storage.getInt(key);

  @override
  Future<void> setString(String key, String value) => _storage.setString(key, value);

  @override
  Future<void> setInt(String key, int value) => _storage.setInt(key, value);

  @override
  List<String>? getStringList(String key) => _storage.getStringList(key);

  @override
  Future<bool> setStringList(String key, List<String> value) => _storage.setStringList(key, value);

  @override
  Future<void> remove(String key) => _storage.remove(key);

  @override
  Future<void> clear() => _storage.clear();

  @override
  Future<void> reload() => _storage.reload();
}
