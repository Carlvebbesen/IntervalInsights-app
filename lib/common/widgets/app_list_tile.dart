import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback? onTap;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? AppColors.accent.withValues(alpha: 0.5)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 1)
            : BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: subtitle,
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}
