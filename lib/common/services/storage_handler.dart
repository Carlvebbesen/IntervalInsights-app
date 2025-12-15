import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {
  final _secureStorage = const FlutterSecureStorage();

  StorageHandler._private();
  static final StorageHandler _instance = StorageHandler._private();
  factory StorageHandler() => _instance;
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String? readFromStorage(String key) {
    return _sharedPrefs.getString(key);
  }

  List<String> readListFromStorage(String key) {
    return _sharedPrefs.getStringList(key) ?? [];
  }

  FutureOr<T?> readFromSecureStorage<T>(String key) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    // storage returns only strings; attempt JSON decode if not primitive
    return value as T?;
  }

  Future<bool> writeToStorage(String key, String value) async {
    return _sharedPrefs.setString(key, value);
  }

  Future<bool> writeListToStorage(String key, List<String> value) async {
    return _sharedPrefs.setStringList(key, value);
  }

  Future<void> writeToSecureStorage<T>(String key, T value) async {
    return _secureStorage.write(key: key, value: value.toString());
  }

  Future<bool> deleteFromStorage(String key) async {
    return _sharedPrefs.remove(key);
  }

  Future<void> deleteFromSecureStorage(String key) async {
    return _secureStorage.delete(key: key);
  }
}
