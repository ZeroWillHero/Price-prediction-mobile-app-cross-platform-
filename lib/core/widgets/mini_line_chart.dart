import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/trend_point.dart';

class MiniLineChart extends StatelessWidget {
  const MiniLineChart({
    super.key,
    required this.series,
    required this.color,
    this.height = 58,
    this.showDots = false,
  });

  final List<double> series;
  final Color color;
  final double height;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (series.length - 1).toDouble(),
          minY: series.reduce((double a, double b) => a < b ? a : b) - 8,
          maxY: series.reduce((double a, double b) => a > b ? a : b) + 8,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: List<FlSpot>.generate(
                series.length,
                (int index) => FlSpot(index.toDouble(), series[index]),
              ),
              isCurved: true,
              color: color,
              barWidth: 2.4,
              dotData: FlDotData(show: showDots),
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastLineChart extends StatelessWidget {
  const ForecastLineChart({
    super.key,
    required this.actual,
    required this.xgboost,
    required this.hybrid,
    required this.labels,
  });

  final List<TrendPoint> actual;
  final List<TrendPoint> xgboost;
  final List<TrendPoint> hybrid;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final double minY = <double>[
      ...actual.map((TrendPoint point) => point.value),
      ...xgboost.map((TrendPoint point) => point.value),
      ...hybrid.map((TrendPoint point) => point.value),
    ].reduce((double a, double b) => a < b ? a : b);

    final double maxY = <double>[
      ...actual.map((TrendPoint point) => point.value),
      ...xgboost.map((TrendPoint point) => point.value),
      ...hybrid.map((TrendPoint point) => point.value),
    ].reduce((double a, double b) => a > b ? a : b);

    return AspectRatio(
      aspectRatio: 1.62,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (labels.length - 1).toDouble(),
          minY: minY - 10,
          maxY: maxY + 10,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (double value) => FlLine(
              color: Theme.of(context).dividerColor.withOpacity(0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: 2,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final int index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      labels[index],
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: <LineChartBarData>[
            _bar(
              actual,
              Theme.of(context).colorScheme.onSurface,
              2.5,
              showDots: false,
            ),
            _bar(
              xgboost,
              const Color(0xFF8B5CF6),
              2,
              dashArray: <int>[6, 5],
            ),
            _bar(
              hybrid,
              Theme.of(context).colorScheme.error,
              2.5,
              showDots: true,
              fillColor: Theme.of(context).colorScheme.error.withOpacity(0.12),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }

  LineChartBarData _bar(
    List<TrendPoint> points,
    Color color,
    double width, {
    bool showDots = false,
    List<int>? dashArray,
    Color? fillColor,
  }) {
    return LineChartBarData(
      spots: points
          .map((TrendPoint point) => FlSpot(point.index.toDouble(), point.value))
          .toList(growable: false),
      isCurved: true,
      color: color,
      barWidth: width,
      dashArray: dashArray,
      dotData: FlDotData(show: showDots),
      belowBarData: BarAreaData(
        show: fillColor != null,
        color: fillColor ?? Colors.transparent,
      ),
    );
  }
}
