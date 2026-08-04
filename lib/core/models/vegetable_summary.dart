import 'package:flutter/material.dart';

class VegetableSummary {
  const VegetableSummary({
    required this.id,
    required this.name,
    required this.currentPrice,
    required this.changePercent,
    required this.description,
    required this.accentColor,
  });

  /// The backend identifier (lowercase, underscore-separated, e.g. `snake_gourd`).
  final String id;

  /// Human-readable display label (e.g. `Snake Gourd`).
  final String name;
  final double currentPrice;
  final double changePercent;
  final String description;
  final Color accentColor;
}
