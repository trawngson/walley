import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;
  const SectionHeader({super.key, required this.icon, required this.title, this.onAction, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: Icon(Icons.ios_share, size: 16, color: Theme.of(context).hintColor.withAlpha(180)),
            label: Text(actionLabel ?? 'Action'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).hintColor.withAlpha(180),
            ),
          ),
      ],
    );
  }
}
