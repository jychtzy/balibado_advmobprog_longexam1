import 'package:flutter/material.dart';

/// Small tappable icon+label control used for post/comment actions
/// (like, comment count, etc.)
class CustomInkwellButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const CustomInkwellButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).textTheme.bodyMedium?.color;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: effectiveColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: effectiveColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
