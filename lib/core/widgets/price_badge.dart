import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum TrendDirection { up, down, flat }

class PriceBadge extends StatelessWidget {
  const PriceBadge({
    super.key,
    required this.label,
    required this.positive,
    this.trend,
    this.toneColor,
  });

  final String label;
  final bool positive;
  final TrendDirection? trend;
  final Color? toneColor;

  @override
  Widget build(BuildContext context) {
    final Color color = toneColor ?? (positive ? AppColors.accent : AppColors.danger);
    final IconData? icon = switch (trend) {
      TrendDirection.up => Icons.arrow_drop_up,
      TrendDirection.down => Icons.arrow_drop_down,
      _ => null,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 1),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
