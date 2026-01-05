import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class BuildStatsBadge extends StatelessWidget {
  const BuildStatsBadge({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = AppColors.accentStrong,
    this.color = AppColors.primary,
    this.bgColor = Colors.blue,
    this.spacing = 6,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  final double spacing;
  final MaterialColor bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: iconColor.withValues(alpha: .2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [
            Icon(icon, size: 18, color: iconColor),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
