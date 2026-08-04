import 'package:flutter/material.dart';

import '../models/alert_models.dart';
import '../models/dated_price.dart';
import '../models/explainability_models.dart';
import '../models/forecast_models.dart';
import '../models/history_models.dart';
import '../models/vegetable_summary.dart';
import '../network/api_models.dart';
import '../network/vege_predict_api.dart';
import '../theme/app_colors.dart';
import '../widgets/vegetable_avatar.dart';

/// Live repository backed by the VegePredict REST API. All price/forecast
/// data is fetched once via [load] and cached in memory; alerts and
/// explainability copy are app-local (the API has no endpoints for them).
class ApiMarketRepository {
  ApiMarketRepository({VegePredictApi? api}) : _api = api ?? VegePredictApi();

  final VegePredictApi _api;

  List<VegetableSummary> _vegetables = <VegetableSummary>[];
  final Map<String, List<DatedPrice>> _prices = <String, List<DatedPrice>>{};
  final Map<String, List<ForecastOut>> _future = <String, List<ForecastOut>>{};
  final Map<String, double> _typicalErrorRs = <String, double>{};

  List<VegetableSummary> get vegetables => _vegetables;

  Future<void> load() async {
    final List<String> ids = await _api.listVegetables();

    final List<VegetableSummary> loaded = await Future.wait(
      ids.map((String id) => _loadVegetable(id)),
    );

    _vegetables = loaded;
  }

  Future<VegetableSummary> _loadVegetable(String id) async {
    final List<HistoricalPriceOut> history = await _api.priceHistory(id);
    final List<ForecastOut> future = await _api.futurePredictions(id);
    final List<ModelMetricOut> metrics = await _api.models(vegetable: id);

    final List<DatedPrice> points = <DatedPrice>[
      ...history.map(
        (HistoricalPriceOut row) => DatedPrice(
          date: row.weekStart,
          price: row.retailPrice,
          isPredicted: false,
        ),
      ),
      ...future.map(
        (ForecastOut row) => DatedPrice(
          date: row.forecastDate,
          price: row.predictedPrice,
          isPredicted: true,
        ),
      ),
    ];
    _prices[id] = points;
    _future[id] = future;
    if (metrics.isNotEmpty) {
      _typicalErrorRs[id] = metrics.first.mae;
    }

    final double currentPrice = _nearestForecast(future, DateTime.now())
            ?.predictedPrice ??
        (history.isNotEmpty ? history.last.retailPrice : 0);
    final double changePercent = history.length >= 2
        ? ((history.last.retailPrice -
                    history[history.length - 2].retailPrice) /
                history[history.length - 2].retailPrice) *
            100
        : 0;

    return VegetableSummary(
      id: id,
      name: _displayName(id),
      currentPrice: currentPrice,
      changePercent: changePercent,
      description: _description(id),
      accentColor: vegAccents[id] ?? AppColors.accent,
    );
  }

  String _displayName(String id) {
    return id
        .split('_')
        .map((String w) =>
            w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  String _description(String id) {
    final String name = _displayName(id);
    return '$name prices are updated weekly from market data and the latest AI forecast.';
  }

  static const VegetableSummary _emptyVegetable = VegetableSummary(
    id: '',
    name: '',
    currentPrice: 0,
    changePercent: 0,
    description: '',
    accentColor: AppColors.accent,
  );

  VegetableSummary get featuredVegetable {
    if (_vegetables.isEmpty) return _emptyVegetable;
    return _vegetables.reduce(
      (VegetableSummary current, VegetableSummary next) =>
          current.changePercent.abs() >= next.changePercent.abs()
              ? current
              : next,
    );
  }

  VegetableSummary vegetableById(String id) {
    return _vegetables.firstWhere(
      (VegetableSummary v) => v.id == id,
      orElse: () => _vegetables.isNotEmpty ? _vegetables.first : _emptyVegetable,
    );
  }

  List<VegetableSummary> get trendingVegetables {
    final List<VegetableSummary> sorted =
        List<VegetableSummary>.of(_vegetables);
    sorted.sort(
      (VegetableSummary a, VegetableSummary b) =>
          b.changePercent.abs().compareTo(a.changePercent.abs()),
    );
    return sorted;
  }

  /// Every recorded and predicted weekly price for a vegetable, oldest first.
  List<DatedPrice> pricesFor(String id) => _prices[id] ?? const <DatedPrice>[];

  /// The predicted price for the week closest to today, or null if no
  /// future forecast has been generated for this vegetable yet.
  double? presentWeekPrediction(String id) {
    final List<ForecastOut> future = _future[id] ?? const <ForecastOut>[];
    return _nearestForecast(future, DateTime.now())?.predictedPrice;
  }

  /// The forecast whose date is closest to [target], or null if [future] is empty.
  ForecastOut? _nearestForecast(List<ForecastOut> future, DateTime target) {
    if (future.isEmpty) return null;
    ForecastOut nearest = future.first;
    Duration best = future.first.forecastDate.difference(target).abs();
    for (final ForecastOut row in future) {
      final Duration diff = row.forecastDate.difference(target).abs();
      if (diff < best) {
        best = diff;
        nearest = row;
      }
    }
    return nearest;
  }

  ForecastPackage forecastFor(String id, String horizon) {
    final int weeks = _weeksFor(horizon);
    final DateTime target = DateTime.now().add(Duration(days: 7 * weeks));
    final List<ForecastOut> future = _future[id] ?? const <ForecastOut>[];
    final ForecastOut? nearest = _nearestForecast(future, target);

    final double predicted =
        nearest?.predictedPrice ?? vegetableById(id).currentPrice;
    return ForecastPackage(
      vegetableId: id,
      horizon: horizon,
      predictedPrice: predicted,
      lowPrice: nearest?.predictedLower ?? predicted,
      highPrice: nearest?.predictedUpper ?? predicted,
      modelFamily: nearest?.modelFamily ?? 'best',
      typicalErrorRs: _typicalErrorRs[id] ?? 0,
    );
  }

  int _weeksFor(String horizon) {
    switch (horizon) {
      case '1W':
        return 1;
      case '2W':
        return 2;
      case '8W':
        return 8;
      case '12W':
        return 12;
      case '4W':
      default:
        return 4;
    }
  }

  // ── App-local features the API has no endpoints for ──────────────────────

  List<AlertRule> get initialAlerts => const <AlertRule>[
        AlertRule(
          id: 1,
          vegetableId: 'carrot',
          comparison: AlertComparison.above,
          threshold: 350,
          enabled: true,
          createdLabel: '10 June',
        ),
        AlertRule(
          id: 2,
          vegetableId: 'leeks',
          comparison: AlertComparison.below,
          threshold: 200,
          enabled: true,
          createdLabel: '8 June',
        ),
        AlertRule(
          id: 3,
          vegetableId: 'pumpkin',
          comparison: AlertComparison.above,
          threshold: 300,
          enabled: false,
          createdLabel: '2 June',
        ),
      ];

  List<AlertHistoryEntry> alertHistoryFor(String id) {
    return _alertHistory[id] ?? const <AlertHistoryEntry>[];
  }

  final Map<String, List<AlertHistoryEntry>> _alertHistory =
      const <String, List<AlertHistoryEntry>>{
    'carrot': <AlertHistoryEntry>[
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
    'leeks': <AlertHistoryEntry>[
      AlertHistoryEntry(
        vegetableName: 'Leeks',
        summary: 'exceeded Rs 250/kg',
        whenLabel: '10 Jun, 7:00 AM',
        actualPriceLabel: 'Rs 252',
      ),
    ],
  };

  List<ExplainabilityLayer> get explainabilityLayers =>
      const <ExplainabilityLayer>[
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
              'It studied years of prices and learned how weather and seasons move the price of each vegetable.',
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
}
