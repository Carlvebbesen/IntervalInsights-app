import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StravaAuthWebView extends StatefulWidget {
  final String authUrl;
  final void Function(String code) onSuccess;
  final void Function(String error) onError;

  const StravaAuthWebView({
    super.key,
    required this.authUrl,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<StravaAuthWebView> createState() => _StravaAuthWebViewState();
}

class _StravaAuthWebViewState extends State<StravaAuthWebView> {
  late WebViewController controller;
  bool loading = true;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer()),
  };

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted && progress == 100) {
              setState(() {
                loading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
              const String.fromEnvironment("REDIRECT_URL"),
            )) {
              _handleRedirect(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));

    if (Platform.isIOS) {
      // Updated User Agent to ensure Google Sign-In (if used by Strava) works
      controller.setUserAgent(
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_7_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1",
      );
    }
  }

  void _handleRedirect(String url) {
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];
    final error = uri.queryParameters['error'];

    if (code != null) {
      widget.onSuccess(code);
    } else if (error != null) {
      widget.onError("Strava Error: $error");
    } else {
      widget.onError("Unknown error: No code returned");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return WebViewWidget(
      controller: controller,
      gestureRecognizers: gestureRecognizers,
    );
  }
}
