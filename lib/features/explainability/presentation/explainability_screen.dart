import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/forecast_models.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';

class ExplainabilityScreen extends StatefulWidget {
  const ExplainabilityScreen({super.key});

  @override
  State<ExplainabilityScreen> createState() => _ExplainabilityScreenState();
}

class _ExplainabilityScreenState extends State<ExplainabilityScreen> {
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final ForecastPackage forecast =
        controller.repository.forecastFor(controller.selectedVegetable.name, controller.selectedHorizon);
    final layers = controller.repository.explainabilityLayers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How it works'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: <Widget>[
          ToggleButtons(
            isSelected: <bool>[_language == 'en', _language == 'si'],
            onPressed: (int index) => setState(() => _language = index == 0 ? 'en' : 'si'),
            children: const <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('EN')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('සිං')),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Text('3 layers, one prediction', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  'How AgriPredict turns data into a price you can trust.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...layers.asMap().entries.expand(
                (entry) => <Widget>[
                  AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: entry.value.color.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(entry.value.icon, color: entry.value.color),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Layer ${entry.key + 1}',
                                style: TextStyle(
                                  color: entry.value.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _language == 'si' ? entry.value.titleSi : entry.value.titleEn,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(entry.value.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (entry.key < layers.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: Icon(Icons.keyboard_arrow_down)),
                    ),
                ],
              )
              .toList(growable: false),
          const SizedBox(height: 8),
          AppCard(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.14),
            child: Column(
              children: <Widget>[
                Chip(label: Text(_language == 'si' ? 'ඔබගේ අනාවැකිය' : 'Your prediction')),
                const SizedBox(height: 10),
                Text(
                  formatRs(forecast.predictedPrice),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text('80% confidence · ${controller.selectedHorizon} ahead'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
