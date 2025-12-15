import 'dart:async';
import 'package:clerk_auth/clerk_auth.dart';
import 'package:interval_insights_app/common/services/storage_handler.dart';

class SecurePersistor implements Persistor {
  SecurePersistor._private();
  static final SecurePersistor _instance = SecurePersistor._private();
  factory SecurePersistor() => _instance;
  @override
  Future<void> initialize() async {}

  @override
  void terminate() {
    // nothing to clean up
  }

  @override
  FutureOr<T?> read<T>(String key) async {
    return StorageHandler().readFromSecureStorage(key);
  }

  @override
  FutureOr<void> write<T>(String key, T value) async {
    await StorageHandler().writeToSecureStorage(key, value);
  }

  @override
  FutureOr<void> delete(String key) async {
    await StorageHandler().deleteFromSecureStorage(key);
  }
}
