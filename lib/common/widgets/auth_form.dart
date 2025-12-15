import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/app_text_field.dart';

class AuthForm extends ConsumerStatefulWidget {
  final bool isSignUp;
  final VoidCallback onToggleMode;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.onToggleMode,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AuthForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSignUp != widget.isSignUp) {
      _formKey.currentState?.reset();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    // Add logic to check Ref loading state here if needed
    if (widget.isSignUp) {
      ref
          .read(authControllerProvider.notifier)
          .signUp(
            email,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
          );
    } else {
      ref.read(authControllerProvider.notifier).requestOtp(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Inputs Animation
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: "First Name",
                        controller: _firstNameController,
                        icon: Icons.person_outline,
                        hint: "Jane",
                        validator: (v) =>
                            widget.isSignUp && (v?.isEmpty ?? true)
                            ? "Required"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: "Last Name",
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        hint: "Doe",
                        validator: (v) =>
                            widget.isSignUp && (v?.isEmpty ?? true)
                            ? "Required"
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
            crossFadeState: widget.isSignUp
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOutQuart,
          ),

          // Email Input
          AppTextField(
            label: "Email Address",
            controller: _emailController,
            icon: Icons.alternate_email,
            hint: "you@example.com",
            keyboardType: TextInputType.emailAddress,
            isLast: true,
            validator: (value) {
              if (value == null || !value.contains('@')) return 'Invalid email';
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Action Button
          AppButton(
            label: widget.isSignUp ? 'Create Account' : 'Send Code',
            onPressed: _submit,
            isLoading: isLoading,
            type: AppButtonType.primary,
          ),

          const SizedBox(height: 24),

          // Toggle Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isSignUp
                    ? "Already have an account? "
                    : "Don't have an account? ",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              AppButton(
                label: widget.isSignUp ? "Sign In" : "Create one",
                onPressed: widget.onToggleMode,
                type: AppButtonType.text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
