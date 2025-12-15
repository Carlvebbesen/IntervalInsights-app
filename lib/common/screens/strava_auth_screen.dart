import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/api/strava_api.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/utils/toast_helper.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/strava_web_view.dart';

class StravaAuthScreen extends ConsumerWidget {
  const StravaAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.tangerineDream,
      appBar: AppBar(
        backgroundColor: AppColors.tangerineDream,
        leading: IconButton(
          color: AppColors.deepTwilight,
          onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Connect to Strava',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.deepTwilight,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 24),
          const Text(
            'To analyze your performance, we need access to your activities. Connect your Strava account to start syncing your data.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: AppColors.deepTwilight),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: "Connect",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                clipBehavior: Clip.hardEdge,
                builder: (context) {
                  return const StravaBottomSheet();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class StravaBottomSheet extends ConsumerStatefulWidget {
  const StravaBottomSheet({super.key});

  @override
  ConsumerState<StravaBottomSheet> createState() => _StravaBottomSheetState();
}

class _StravaBottomSheetState extends ConsumerState<StravaBottomSheet> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return FutureBuilder(
          future: StravaService().getAuthUrl(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ToastHelper.showError(title: "Could not load strava");
              });
            }
            final showAuthView = snapshot.hasData && snapshot.data != null;
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: AppColors.tangerineDream,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Strava",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepTwilight,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.deepTwilight,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  _content(showAuthView, isCompleted, snapshot, context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Expanded _content(
    bool showAuthView,
    bool isCompleted,
    AsyncSnapshot<String> snapshot,
    BuildContext context,
  ) {
    if (isCompleted) {
      return const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Setting up strava ...."),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }
    return Expanded(
      child: showAuthView
          ? StravaAuthWebView(
              authUrl: snapshot.data!,
              redirectUrl: "http://localhost:3000",
              onSuccess: (code) async {
                setState(() {
                  isCompleted = true;
                });
                ref
                    .read(authControllerProvider.notifier)
                    .handleStravaAuthCompleted(code);
              },
              onError: (err) {
                context.pop();
                ToastHelper.showError(title: "Could not connect");
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
