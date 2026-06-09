import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/trend_point.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/mini_line_chart.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/vegetable_avatar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _range = '3M';

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final history = controller.repository.historyFor(vegetable.name);
    final stats = _buildStats(history);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text('Price history', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        AppCard(
          child: Row(
            children: <Widget>[
              VegetableAvatar(name: vegetable.name, color: vegetable.accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: vegetable.name,
                    isExpanded: true,
                    items: controller.repository.vegetables
                        .map(
                          (veg) => DropdownMenuItem<String>(
                            value: veg.name,
                            child: Text(veg.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      context.read<AppController>().selectVegetable(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <String>['1M', '3M', '6M', '1Y', 'All']
              .map(
                (String value) => ChoiceChip(
                  label: Text(value),
                  selected: _range == value,
                  onSelected: (_) => setState(() => _range = value),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            Expanded(
              child: StatCard(
                icon: Icons.arrow_downward,
                label: 'Min price',
                value: 'Rs ${stats.min.toStringAsFixed(0)}',
                subLabel: stats.minLabel,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                icon: Icons.arrow_upward,
                label: 'Max price',
                value: 'Rs ${stats.max.toStringAsFixed(0)}',
                subLabel: stats.maxLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: StatCard(
                icon: Icons.remove,
                label: 'Average',
                value: 'Rs ${stats.avg.toStringAsFixed(0)}',
                subLabel: 'This period',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                icon: Icons.show_chart,
                label: 'Volatility',
                value: 'Rs ${stats.volatility.toStringAsFixed(0)}',
                subLabel: 'Std dev',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: MediaQuery.of(context).size.width * 0.34,
                top: 20,
                bottom: 36,
                right: MediaQuery.of(context).size.width * 0.26,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.18),
                    ),
                  ),
                ),
              ),
              ForecastLineChart(
                actual: history,
                chronos: const <TrendPoint>[],
                hybrid: const <TrendPoint>[],
                labels: const <String>[
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                  'Jan',
                  'Feb',
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 12, height: 12, decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(0.3), borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 6),
                const Text('Crisis period'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.cloud, size: 14, color: Colors.blue),
                SizedBox(width: 6),
                Text('Weather alert'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        SectionHeader(icon: Icons.warning_amber_rounded, title: 'Crisis events'),
        const SizedBox(height: 10),
        ...controller.repository.eventsFor(vegetable.name).map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  child: Row(
                    children: <Widget>[
                      Text(event.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(event.title, style: Theme.of(context).textTheme.titleMedium),
                            Text(event.period, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text(event.deltaLabel, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Export as PDF'),
        ),
      ],
    );
  }

  _HistoryStats _buildStats(List<TrendPoint> history) {
    final List<double> values =
        history.map((TrendPoint point) => point.value).toList(growable: false);
    final double min = values.reduce((double a, double b) => a < b ? a : b);
    final double max = values.reduce((double a, double b) => a > b ? a : b);
    final double avg = values.fold<double>(0, (double sum, double value) => sum + value) / values.length;
    final double variance = values.fold<double>(0, (double sum, double value) => sum + ((value - avg) * (value - avg))) / values.length;
    return _HistoryStats(
      min: min,
      max: max,
      avg: avg,
      volatility: math.sqrt(variance),
      minLabel: '12 May',
      maxLabel: '3 Jun',
    );
  }
}

class _HistoryStats {
  const _HistoryStats({
    required this.min,
    required this.max,
    required this.avg,
    required this.volatility,
    required this.minLabel,
    required this.maxLabel,
  });

  final double min;
  final double max;
  final double avg;
  final double volatility;
  final String minLabel;
  final String maxLabel;
}
