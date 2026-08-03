import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppCardVariant { normal, fire, glass, glow, solid }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.border,
    this.margin,
    this.variant = AppCardVariant.normal,
    this.radius = 20.0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;
  final AppCardVariant variant;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    BoxDecoration decoration;

    switch (variant) {
      case AppCardVariant.fire:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.fireLight, AppColors.fireMid, AppColors.fireDark],
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.32),
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        );
        break;
      case AppCardVariant.glass:
        decoration = BoxDecoration(
          color: (isDark ? AppColors.surface : Colors.white).withOpacity(0.76),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDark ? AppColors.outlineStrong : AppColors.outlineLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        );
        break;
      case AppCardVariant.glow:
        decoration = BoxDecoration(
          color: color ?? (isDark ? AppColors.surface : Colors.white),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.accent.withOpacity(0.28)),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.10),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        );
        break;
      case AppCardVariant.solid:
        decoration = BoxDecoration(
          color: color ?? (isDark ? AppColors.surfaceSunk : AppColors.bgLight),
          borderRadius: BorderRadius.circular(radius),
        );
        break;
      case AppCardVariant.normal:
        decoration = BoxDecoration(
          color: color ?? (isDark ? AppColors.surface : Colors.white),
          borderRadius: BorderRadius.circular(radius),
          border: border ??
              Border.all(
                color: isDark ? AppColors.outline : AppColors.outlineLight,
              ),
        );
    }

    final content = Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        splashColor: AppColors.accent.withOpacity(0.08),
        highlightColor: AppColors.accent.withOpacity(0.04),
        child: content,
      ),
    );
  }
}
