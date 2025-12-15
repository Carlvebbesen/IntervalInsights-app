import 'package:interval_insights_app/common/services/storage_handler.dart';

class ServiceInitializer {
  static Future<void> initialize() async {
    await StorageHandler().init();
  }
}
