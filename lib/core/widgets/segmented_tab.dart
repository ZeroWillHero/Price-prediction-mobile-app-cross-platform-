import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SegmentedTab extends StatelessWidget {
  const SegmentedTab({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface2 : AppColors.bgLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isDark ? AppColors.outline : AppColors.outlineLight,
        ),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.surface : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.14),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.text : const Color(0xFF0F1F17))
                        : (isDark ? AppColors.textSecondary : const Color(0xFF587165)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
