import 'package:flutter/material.dart';

import '../models/alert_models.dart';
import '../models/explainability_models.dart';
import '../models/forecast_models.dart';
import '../models/history_models.dart';
import '../models/trend_point.dart';
import '../models/vegetable_summary.dart';
import '../theme/app_colors.dart';

class MockMarketRepository {
  MockMarketRepository();

  List<VegetableSummary> get vegetables => _vegetables;

  VegetableSummary get featuredVegetable => vegetables.reduce(
        (VegetableSummary current, VegetableSummary next) =>
            current.changePercent.abs() >= next.changePercent.abs() ? current : next,
      );

  VegetableSummary vegetableByName(String name) {
    return vegetables.firstWhere(
      (VegetableSummary vegetable) => vegetable.name == name,
      orElse: () => vegetables.first,
    );
  }

  ForecastPackage forecastFor(String vegetableName, String horizon) {
    final _ForecastSeed seed = _forecastSeeds[vegetableName] ?? _forecastSeeds['Carrot']!;
    final double factor = _horizonFactors[horizon] ?? 1;
    return ForecastPackage(
      vegetableName: vegetableName,
      horizon: horizon,
      predictedPrice: seed.predictedPrice * factor,
      lowPrice: seed.lowPrice * factor,
      highPrice: seed.highPrice * factor,
      actualSeries: _points(seed.actualValues),
      chronosSeries: _points(seed.chronosValues),
      hybridSeries: _points(seed.hybridValues),
      influences: seed.influences,
      insight: seed.insight,
    );
  }

  List<TrendPoint> historyFor(String vegetableName) {
    return _historySeries[vegetableName] ?? _historySeries['Carrot']!;
  }

  List<HistoryEvent> eventsFor(String vegetableName) {
    return _events[vegetableName] ?? _events['Carrot']!;
  }

  List<AlertHistoryEntry> alertHistoryFor(String vegetableName) {
    return _alertHistory[vegetableName] ?? _alertHistory['Carrot']!;
  }

  List<HistoryEvent> get genericCrisisEvents => const <HistoryEvent>[
        HistoryEvent(
          emoji: '🔴',
          title: 'Fuel crisis',
          period: 'Feb 2024',
          deltaLabel: '+8%',
        ),
        HistoryEvent(
          emoji: '🌧️',
          title: 'Heavy monsoon',
          period: 'Mar 2024',
          deltaLabel: '+12%',
        ),
      ];

  List<AlertRule> get initialAlerts => const <AlertRule>[
        AlertRule(
          id: 1,
          vegetableName: 'Carrot',
          comparison: AlertComparison.above,
          threshold: 350,
          enabled: true,
          createdLabel: '10 June',
        ),
        AlertRule(
          id: 2,
          vegetableName: 'Leeks',
          comparison: AlertComparison.below,
          threshold: 200,
          enabled: true,
          createdLabel: '8 June',
        ),
        AlertRule(
          id: 3,
          vegetableName: 'Pumpkin',
          comparison: AlertComparison.above,
          threshold: 300,
          enabled: false,
          createdLabel: '2 June',
        ),
      ];

  List<ExplainabilityLayer> get explainabilityLayers => const <ExplainabilityLayer>[
        ExplainabilityLayer(
          icon: Icons.newspaper,
          color: AppColors.amber,
          titleEn: 'Market news',
          titleSi: 'වෙළඳපල ප්‍රවෘත්ති',
          description:
              'The AI reads news about fuel shortages, political events, and natural disasters that move vegetable prices.',
        ),
        ExplainabilityLayer(
          icon: Icons.psychology,
          color: AppColors.info,
          titleEn: 'AI pattern finder',
          titleSi: 'රටා හඳුනාගැනීම',
          description:
              'It studied 25 years of prices and learned that carrots cost more after rainy seasons and cheaper after harvest.',
        ),
        ExplainabilityLayer(
          icon: Icons.tune,
          color: AppColors.success,
          titleEn: 'Smart corrector',
          titleSi: 'බුද්ධිමත් නිවැරදිකරණය',
          description:
              'If fuel prices rise today, the corrector nudges the base prediction upward to match real conditions.',
        ),
      ];

  final Map<String, List<TrendPoint>> _historySeries = const <String, List<TrendPoint>>{
    'Carrot': <TrendPoint>[
      TrendPoint(index: 0, label: 'Mar', value: 250),
      TrendPoint(index: 1, label: 'Apr', value: 268),
      TrendPoint(index: 2, label: 'May', value: 245),
      TrendPoint(index: 3, label: 'Jun', value: 280),
      TrendPoint(index: 4, label: 'Jul', value: 310),
      TrendPoint(index: 5, label: 'Aug', value: 295),
      TrendPoint(index: 6, label: 'Sep', value: 330),
      TrendPoint(index: 7, label: 'Oct', value: 352),
      TrendPoint(index: 8, label: 'Nov', value: 300),
      TrendPoint(index: 9, label: 'Dec', value: 315),
      TrendPoint(index: 10, label: 'Jan', value: 305),
      TrendPoint(index: 11, label: 'Feb', value: 320),
    ],
    'Leeks': <TrendPoint>[
      TrendPoint(index: 0, label: 'Mar', value: 200),
      TrendPoint(index: 1, label: 'Apr', value: 215),
      TrendPoint(index: 2, label: 'May', value: 210),
      TrendPoint(index: 3, label: 'Jun', value: 225),
      TrendPoint(index: 4, label: 'Jul', value: 230),
      TrendPoint(index: 5, label: 'Aug', value: 222),
      TrendPoint(index: 6, label: 'Sep', value: 240),
      TrendPoint(index: 7, label: 'Oct', value: 255),
      TrendPoint(index: 8, label: 'Nov', value: 248),
      TrendPoint(index: 9, label: 'Dec', value: 252),
      TrendPoint(index: 10, label: 'Jan', value: 246),
      TrendPoint(index: 11, label: 'Feb', value: 250),
    ],
  };

  final Map<String, List<HistoryEvent>> _events = const <String, List<HistoryEvent>>{
    'Carrot': <HistoryEvent>[
      HistoryEvent(emoji: '🔴', title: 'Fuel crisis', period: 'Feb 2024', deltaLabel: '+8%'),
      HistoryEvent(emoji: '🌧️', title: 'Heavy monsoon', period: 'Mar 2024', deltaLabel: '+12%'),
    ],
    'Leeks': <HistoryEvent>[
      HistoryEvent(emoji: '🚨', title: 'Transport delay', period: 'Apr 2024', deltaLabel: '+9%'),
      HistoryEvent(emoji: '🌧️', title: 'Rainfall spike', period: 'May 2024', deltaLabel: '+11%'),
    ],
  };

  final Map<String, List<AlertHistoryEntry>> _alertHistory = const <String, List<AlertHistoryEntry>>{
    'Carrot': <AlertHistoryEntry>[
      AlertHistoryEntry(
        vegetableName: 'Carrot',
        summary: 'exceeded Rs 350/kg',
        whenLabel: '15 Jun, 2:30 PM',
        actualPriceLabel: 'Rs 355',
      ),
      AlertHistoryEntry(
        vegetableName: 'Leeks',
        summary: 'dropped below Rs 200/kg',
        whenLabel: '14 Jun, 9:10 AM',
        actualPriceLabel: 'Rs 195',
      ),
    ],
    'Leeks': <AlertHistoryEntry>[
      AlertHistoryEntry(
        vegetableName: 'Leeks',
        summary: 'exceeded Rs 250/kg',
        whenLabel: '10 Jun, 7:00 AM',
        actualPriceLabel: 'Rs 252',
      ),
    ],
  };

  final Map<String, _ForecastSeed> _forecastSeeds = <String, _ForecastSeed>{
    'Carrot': _ForecastSeed(
      predictedPrice: 345,
      lowPrice: 330,
      highPrice: 360,
      actualValues: <double?>[300, 305, 298, 312, 318, 305, 320, 322, 318, 330, 338, 345],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 318, 326, 332, 340],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 318, 330, 339, 345],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '40%', title: 'News & crisis'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '35%', title: 'Seasonal'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '25%', title: 'Fuel prices'),
      ],
      insight:
          'Carrot prices usually climb after rainy seasons. The model sees that pattern across 25 years of market data.',
    ),
    'Leeks': _ForecastSeed(
      predictedPrice: 255,
      lowPrice: 240,
      highPrice: 268,
      actualValues: <double?>[200, 215, 210, 225, 230, 222, 240, 242, 246, 250, 252, 255],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 238, 244, 249, 252],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 240, 248, 252, 255],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '45%', title: 'Transport news'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '30%', title: 'Seasonal shift'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '25%', title: 'Fuel costs'),
      ],
      insight:
          'Leeks are highly seasonal and sensitive to transport fuel costs, so short-term swings can be sharper.',
    ),
    'Brinjal': _ForecastSeed(
      predictedPrice: 186,
      lowPrice: 176,
      highPrice: 194,
      actualValues: <double?>[190, 188, 185, 182, 186, 184, 180, 179, 181, 183, 185, 186],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 181, 183, 185, 186],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 181, 184, 185, 186],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '20%', title: 'Market news'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '50%', title: 'Harvest timing'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '30%', title: 'Logistics'),
      ],
      insight: 'Brinjal stays stable through most of the year, easing slightly after the main harvest window.',
    ),
    'Pumpkin': _ForecastSeed(
      predictedPrice: 294,
      lowPrice: 286,
      highPrice: 305,
      actualValues: <double?>[310, 305, 300, 298, 295, 292, 290, 289, 290, 292, 293, 294],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 291, 292, 293, 294],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 290, 292, 293, 294],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '35%', title: 'Import news'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '40%', title: 'Stock levels'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '25%', title: 'Fuel costs'),
      ],
      insight: 'Pumpkin tracks import patterns closely and is cooling as fresh local stock reaches the markets.',
    ),
    'Cabbage': _ForecastSeed(
      predictedPrice: 155,
      lowPrice: 148,
      highPrice: 162,
      actualValues: <double?>[146, 148, 145, 149, 150, 148, 150, 151, 153, 154, 155, 155],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 151, 153, 154, 155],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 151, 153, 154, 155],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '15%', title: 'Market news'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '60%', title: 'Stable demand'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '25%', title: 'Distribution'),
      ],
      insight: 'Cabbage is one of the calmest movers, with small steady shifts week to week.',
    ),
    'Snake Gourd': _ForecastSeed(
      predictedPrice: 165,
      lowPrice: 155,
      highPrice: 175,
      actualValues: <double?>[150, 154, 152, 158, 160, 157, 162, 163, 161, 164, 165, 165],
      chronosValues: <double?>[null, null, null, null, null, null, null, null, 161, 163, 164, 165],
      hybridValues: <double?>[null, null, null, null, null, null, null, null, 161, 163, 164, 165],
      influences: <InfluenceFactor>[
        InfluenceFactor(icon: Icons.newspaper, color: AppColors.amber, weightLabel: '25%', title: 'Market news'),
        InfluenceFactor(icon: Icons.psychology, color: AppColors.info, weightLabel: '45%', title: 'Seasonal'),
        InfluenceFactor(icon: Icons.local_gas_station, color: AppColors.success, weightLabel: '30%', title: 'Distribution'),
      ],
      insight: 'Snake Gourd demand holds steady with mild seasonal upticks during festival periods.',
    ),
  };

  final List<VegetableSummary> _vegetables = const <VegetableSummary>[
    VegetableSummary(
      name: 'Carrot',
      currentPrice: 320,
      changePercent: 5,
      description:
          'Carrot prices usually climb after rainy seasons. The model sees this pattern across 25 years of market data.',
      sparkline: <double>[300, 305, 298, 312, 318, 305, 320],
      accentColor: AppColors.accent,
    ),
    VegetableSummary(
      name: 'Cabbage',
      currentPrice: 150,
      changePercent: 1,
      description: 'Cabbage is one of the calmest movers — small, steady shifts week to week.',
      sparkline: <double>[146, 148, 145, 149, 150, 148, 150],
      accentColor: AppColors.primaryDark,
    ),
    VegetableSummary(
      name: 'Leeks',
      currentPrice: 240,
      changePercent: 8,
      description:
          'Leeks are highly seasonal and sensitive to transport fuel costs — expect sharper short-term swings.',
      sparkline: <double>[200, 215, 210, 225, 230, 222, 240],
      accentColor: AppColors.info,
    ),
    VegetableSummary(
      name: 'Brinjal',
      currentPrice: 180,
      changePercent: -2,
      description:
          'Brinjal stays stable through most of the year, easing slightly after the main harvest window.',
      sparkline: <double>[190, 188, 185, 182, 186, 184, 180],
      accentColor: AppColors.success,
    ),
    VegetableSummary(
      name: 'Pumpkin',
      currentPrice: 290,
      changePercent: -3,
      description:
          'Pumpkin tracks import patterns closely and is cooling as fresh local stock reaches the markets.',
      sparkline: <double>[310, 305, 300, 298, 295, 292, 290],
      accentColor: AppColors.primary,
    ),
    VegetableSummary(
      name: 'Snake Gourd',
      currentPrice: 165,
      changePercent: 3,
      description: 'Snake Gourd demand holds steady with mild seasonal upticks during festival periods.',
      sparkline: <double>[150, 154, 152, 158, 160, 157, 162],
      accentColor: AppColors.amber,
    ),
  ];

  final Map<String, double> _horizonFactors = const <String, double>{
    '1W': 0.96,
    '2W': 0.98,
    '4W': 1.00,
    '8W': 1.05,
    '12W': 1.08,
  };

  List<VegetableSummary> get trendingVegetables {
    final List<VegetableSummary> sorted = List<VegetableSummary>.of(vegetables);
    sorted.sort(
      (VegetableSummary a, VegetableSummary b) =>
          b.changePercent.abs().compareTo(a.changePercent.abs()),
    );
    return sorted;
  }

  List<TrendPoint> _points(List<double?> values) {
    final List<TrendPoint> points = <TrendPoint>[];
    for (int index = 0; index < values.length; index += 1) {
      final double? value = values[index];
      if (value == null) {
        continue;
      }
      points.add(TrendPoint(index: index, label: 'P${index + 1}', value: value));
    }
    return points;
  }
}

class _ForecastSeed {
  const _ForecastSeed({
    required this.predictedPrice,
    required this.lowPrice,
    required this.highPrice,
    required this.actualValues,
    required this.chronosValues,
    required this.hybridValues,
    required this.influences,
    required this.insight,
  });

  final double predictedPrice;
  final double lowPrice;
  final double highPrice;
  final List<double?> actualValues;
  final List<double?> chronosValues;
  final List<double?> hybridValues;
  final List<InfluenceFactor> influences;
  final String insight;
}
