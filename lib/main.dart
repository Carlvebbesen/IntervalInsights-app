import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/routing/router.dart';
import 'package:interval_insights_app/common/services/service_initializer.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceInitializer.initialize();
  runApp(const ProviderScope(child: IntervalInsightsApp()));
}

class IntervalInsightsApp extends ConsumerWidget {
  const IntervalInsightsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        title: 'Interval Insights',
        routerConfig: router,
      ),
    );
  }
}
