import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

const defaultDuration = Duration(seconds: 5);

class ToastHelper {
  static ToastificationItem showError({
    required String title,
    String? description,
    IconData? iconData,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration? autoCloseDuration,
  }) {
    final Color bg = backgroundColor ?? Colors.red.shade200;
    final Color fg = foregroundColor ?? Colors.red;
    return toastification.show(
      title: Text(
        title,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
      description: description != null
          ? Text(description, style: TextStyle(color: fg))
          : null,
      icon: Icon(iconData ?? Icons.info_outline, color: fg),
      backgroundColor: bg,
      autoCloseDuration: autoCloseDuration ?? defaultDuration,
      borderSide: BorderSide(color: fg),
    );
  }

  static ToastificationItem showWarning({
    required String title,
    String? description,
    IconData? iconData,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration? autoCloseDuration,
  }) {
    final Color bg = backgroundColor ?? Colors.amber.shade200;
    final Color fg = foregroundColor ?? Colors.yellow;

    return toastification.show(
      title: Text(
        title,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
      description: description != null
          ? Text(description, style: TextStyle(color: fg))
          : null,
      icon: Icon(iconData ?? Icons.warning_amber_rounded, color: fg),
      backgroundColor: bg,
      autoCloseDuration: autoCloseDuration ?? defaultDuration,
      borderSide: BorderSide(color: fg),
    );
  }

  static ToastificationItem showFeedback({
    required String title,
    String? description,
    IconData? iconData,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration? autoCloseDuration,
  }) {
    final Color bg = backgroundColor ?? Colors.greenAccent.shade200;
    final Color fg = foregroundColor ?? Colors.green;

    return toastification.show(
      title: Text(
        title,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
      description: description != null
          ? Text(description, style: TextStyle(color: fg))
          : null,
      icon: Icon(iconData ?? Icons.notifications_active, color: fg),
      backgroundColor: bg,
      autoCloseDuration: autoCloseDuration ?? defaultDuration,
      borderSide: BorderSide(color: fg),
    );
  }
}
