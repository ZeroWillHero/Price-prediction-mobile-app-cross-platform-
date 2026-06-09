import 'package:flutter/material.dart';

class VegetableSummary {
  const VegetableSummary({
    required this.name,
    required this.currentPrice,
    required this.changePercent,
    required this.description,
    required this.sparkline,
    required this.accentColor,
  });

  final String name;
  final double currentPrice;
  final double changePercent;
  final String description;
  final List<double> sparkline;
  final Color accentColor;
}
