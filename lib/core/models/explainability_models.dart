import 'package:flutter/material.dart';

class ExplainabilityLayer {
  const ExplainabilityLayer({
    required this.icon,
    required this.color,
    required this.titleEn,
    required this.titleSi,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String titleEn;
  final String titleSi;
  final String description;
}
