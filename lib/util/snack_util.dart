import 'package:flutter/material.dart';

class SnackUtil {
  static void showInfo(BuildContext context, String message) {
    _show(context, message, Icons.info_outline_rounded);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Icons.check_circle_outline_rounded,
        color: Colors.greenAccent.shade400,);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Icons.error_outline_rounded,
        color: Colors.redAccent.shade200,);
  }

  static void _show(BuildContext context, String message, IconData icon,
      {Color? color,}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color ?? theme.colorScheme.onInverseSurface),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: theme.colorScheme.inverseSurface,
      ),
    );
  }
}
