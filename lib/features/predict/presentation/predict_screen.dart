import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/forecast_models.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/mini_line_chart.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/vegetable_avatar.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({
    super.key,
    required this.onOpenExplainability,
  });

  final VoidCallback onOpenExplainability;

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  bool _loading = false;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final forecast = controller.repository.forecastFor(vegetable.name, controller.selectedHorizon);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text('Predict', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        AppCard(
          child: Row(
            children: <Widget>[
              VegetableAvatar(name: vegetable.name, color: vegetable.accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(vegetable.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(formatRs(vegetable.currentPrice), style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionHeader(icon: Icons.schedule, title: 'How far ahead do you want to predict?'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <String>['1W', '2W', '4W', '8W', '12W']
              .map(
                (String horizon) => ChoiceChip(
                  label: Text(horizon),
                  selected: controller.selectedHorizon == horizon,
                  onSelected: (_) => context.read<AppController>().setHorizon(horizon),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 12),
        Text(
          'Longer forecasts are less accurate.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: _loading
              ? null
              : () {
                  setState(() {
                    _loading = true;
                    _showResult = false;
                  });
                  Timer(const Duration(milliseconds: 900), () {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _loading = false;
                      _showResult = true;
                    });
                  });
                },
          child: Text(_loading ? 'Predicting…' : 'Predict now'),
        ),
        if (_showResult) ...<Widget>[
          const SizedBox(height: 16),
          AppCard(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            child: Column(
              children: <Widget>[
                Text('Predicted price · ${controller.selectedHorizon}'),
                const SizedBox(height: 6),
                Text(
                  formatRs(forecast.predictedPrice),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expected range: Rs ${forecast.lowPrice.toStringAsFixed(0)} – Rs ${forecast.highPrice.toStringAsFixed(0)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ForecastLineChart(
                  actual: forecast.actualSeries,
                  chronos: forecast.chronosSeries,
                  hybrid: forecast.hybridSeries,
                  labels: const <String>[
                    'W1',
                    'W2',
                    'W3',
                    'W4',
                    'W5',
                    'W6',
                    'W7',
                    'W8',
                    'W9',
                    'W10',
                    'W11',
                    'W12',
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: const <Widget>[
                    _Legend(dotColor: Color(0xFF111827), label: 'Actual'),
                    _Legend(dotColor: Color(0xFF8B5CF6), label: 'Chronos'),
                    _Legend(dotColor: Color(0xFFEF4444), label: 'Hybrid'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(icon: Icons.psychology, title: 'What influenced this prediction?'),
                const SizedBox(height: 10),
                Row(
                  children: forecast.influences
                      .map(
                        (factor) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _InfluenceCard(factor: factor),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 12),
                Text(forecast.insight),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: widget.onOpenExplainability,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('See how the model works'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.read<AppController>().setTab(AppTab.history),
                  icon: const Icon(Icons.show_chart),
                  label: const Text('History'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.dotColor,
    required this.label,
  });

  final Color dotColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _InfluenceCard extends StatelessWidget {
  const _InfluenceCard({
    required this.factor,
  });

  final InfluenceFactor factor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: factor.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Icon(factor.icon, color: factor.color),
          const SizedBox(height: 8),
          Text(factor.weightLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            factor.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
