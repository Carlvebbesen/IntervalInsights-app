import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

// --- GENERIC BUTTON ---
enum AppButtonType { primary, text, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final bool disabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.type = AppButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Text Button Style
    if (type == AppButtonType.text) {
      return TextButton(
        onPressed: disabled
            ? null
            : isLoading
            ? null
            : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      );
    }

    // 2. Primary / Outline Button Config
    final isPrimary = type == AppButtonType.primary;

    return Container(
      decoration: isPrimary
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : (onPressed == null || isLoading)
            ? null
            : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.accent : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : AppColors.accent,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          elevation: 0, // We handle shadow in Container for better glow control
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: isPrimary ? Colors.white : AppColors.accent,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
