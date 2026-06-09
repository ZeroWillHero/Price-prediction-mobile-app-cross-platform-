import 'package:flutter/material.dart';

import 'trend_point.dart';

class InfluenceFactor {
  const InfluenceFactor({
    required this.icon,
    required this.color,
    required this.weightLabel,
    required this.title,
  });

  final IconData icon;
  final Color color;
  final String weightLabel;
  final String title;
}

class ForecastPackage {
  const ForecastPackage({
    required this.vegetableName,
    required this.horizon,
    required this.predictedPrice,
    required this.lowPrice,
    required this.highPrice,
    required this.actualSeries,
    required this.chronosSeries,
    required this.hybridSeries,
    required this.influences,
    required this.insight,
  });

  final String vegetableName;
  final String horizon;
  final double predictedPrice;
  final double lowPrice;
  final double highPrice;
  final List<TrendPoint> actualSeries;
  final List<TrendPoint> chronosSeries;
  final List<TrendPoint> hybridSeries;
  final List<InfluenceFactor> influences;
  final String insight;
}
