import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart'; // Ensure AppColors is here
import 'package:interval_insights_app/common/utils/toast_helper.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _submitOtp(String code) {
    if (code.length != 6) return;
    if (ref.read(authControllerProvider).isLoading) return;
    ref.read(authControllerProvider.notifier).verifyOtpCode(code);
  }

  Future<void> _onResend() async {
    await ref.read(authControllerProvider.notifier).resendOtp();
    ToastHelper.showFeedback(title: "Email sent ");
  }

  void _onChangeEmail() {
    ref.invalidate(authControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final email = authState.value is VerifyOtpCode
        ? (authState.value as VerifyOtpCode).email
        : '';
    final isLoading = authState.isLoading;
    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.accent,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 2,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.secondary, width: 3),
      borderRadius: BorderRadius.circular(16),
      color: AppColors.primary,
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: AppColors.primary,
      border: Border.all(color: AppColors.surfaceCard),
    );

    return Scaffold(
      backgroundColor: AppColors.accent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: _onChangeEmail,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_person_outlined,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM SECTION: INPUTS ---
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verification',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _onChangeEmail,
                      child: Row(
                        children: [
                          Text(
                            'Code sent to ',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.edit,
                            color: AppColors.accent,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // PINPUT WIDGET
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        autofocus: true,
                        // Logic integration
                        onCompleted: (pin) => _submitOtp(pin),
                        onSubmitted: (pin) => _submitOtp(pin),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        validator: (s) {
                          return s?.length == 6 ? null : 'Pin is incorrect';
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Verify Button
                    Center(
                      child: AppButton(
                        label: 'Verify Code',
                        type: AppButtonType
                            .primary, // Ensure this uses your Primary color (maybe Tangerine or Vanilla?)
                        isLoading: isLoading,
                        onPressed: () => _submitOtp(_pinController.text),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: isLoading ? null : _onResend,
                        child: RichText(
                          text: const TextSpan(
                            text: "Didn't receive code? ",
                            style: TextStyle(color: AppColors.textSecondary),
                            children: [
                              TextSpan(
                                text: "Resend",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
