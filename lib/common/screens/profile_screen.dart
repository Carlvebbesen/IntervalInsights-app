import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/api/strava_api.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/routing/routes.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'dart:convert';

import 'package:pinput/pinput.dart'; // For pretty printing JSON

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final StravaService _stravaService = StravaService();
  String _debugResponse = "No data yet";
  bool _isLoading = false;
  final idController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  void _updateUI(dynamic response) {
    setState(() {
      _debugResponse = const JsonEncoder.withIndent('  ').convert(response);
      _isLoading = false;
    });
  }

  Future<void> _handleGetSubscription() async {
    setState(() => _isLoading = true);
    try {
      final res = await _stravaService.getSubscription();
      if (res.isNotEmpty) {
        idController.setText(res.first.id.toString());
      }
      _updateUI(res);
    } catch (e) {
      _updateUI({"error": e.toString()});
    }
  }

  Future<void> _handleDeleteSubscription() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Subscription ID"),
        content: TextField(
          controller: idController,
          decoration: const InputDecoration(hintText: "ID"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await _stravaService.deleteSubscription(idController.text);
                _updateUI({
                  "message": "Successfully deleted ${idController.text}",
                });
              } catch (e) {
                _updateUI({"error": e.toString()});
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          AppButton(
            label: "logout",
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: "Load old activities",
            onPressed: () => context.go(const SyncActivitiesRoute().location),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: "Set up subscription",
            onPressed: () async {
              final res = await _stravaService.debugStartSubscription();
              _updateUI(res.toString());
            },
          ),

          const SizedBox(height: 10),
          AppButton(
            label: "View Subscriptions",
            onPressed: _handleGetSubscription,
          ),
          const SizedBox(height: 10),

          AppButton(
            label: "Delete Subscription",
            onPressed: _handleDeleteSubscription,
          ),
          const SizedBox(height: 10),

          AppButton(
            label: "test handshake",
            onPressed: () async {
              final res = await StravaService().testHandshake();
              _updateUI(res.toString());
            },
          ),
          AppButton(
            label: "test event",
            onPressed: () async {
              final res = await StravaService().testEvent();
              _updateUI(res.toString());
            },
          ),

          const SizedBox(height: 20),
          const Text(
            "Backend Response:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Debugging view for the JSON response
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Text(
                      _debugResponse,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
