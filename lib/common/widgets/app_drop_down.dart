import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.labelText,
    this.prefixIcon,
    this.bgColor = AppColors.accentStrong,
    this.textColor = AppColors.primary,
  });
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String Function(T) itemLabelBuilder;
  final String? labelText;
  final IconData? prefixIcon;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: bgColor.withValues(alpha: 0.2), width: 1),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,

        splashColor: bgColor.withValues(alpha: 0.1),
        highlightColor: bgColor.withValues(alpha: 0.1),
        hoverColor: bgColor.withValues(alpha: 0.05),
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,

        dropdownColor: Colors.white,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: bgColor),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18, color: bgColor)
              : null,
          border: borderStyle,
          enabledBorder: borderStyle,
          focusedBorder: borderStyle.copyWith(
            borderSide: BorderSide(color: bgColor, width: 1.5),
          ),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabelBuilder(item),

              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
