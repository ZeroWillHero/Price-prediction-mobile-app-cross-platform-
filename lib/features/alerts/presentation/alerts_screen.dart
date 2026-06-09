import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/alert_models.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/vegetable_avatar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final activeAlerts = controller.activeAlerts;
    final vegetable = controller.selectedVegetable;
    final history = controller.repository.alertHistoryFor(vegetable.name);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Price alerts', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => _openCreateSheet(context, controller),
              icon: const Icon(Icons.add),
              label: const Text('Create alert'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionHeader(icon: Icons.notifications_active, title: 'Active alerts (${activeAlerts.length})'),
        const SizedBox(height: 10),
        ...controller.alerts.map(
          (alert) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              child: Row(
                children: <Widget>[
                  VegetableAvatar(
                    name: alert.vegetableName,
                    color: controller.repository.vegetableByName(alert.vegetableName).accentColor,
                    size: 42,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          alert.vegetableName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(alert.conditionLabel, style: Theme.of(context).textTheme.bodySmall),
                        Text('Set on ${alert.createdLabel}', style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                  Switch(
                    value: alert.enabled,
                    onChanged: (_) => context.read<AppController>().toggleAlert(alert.id),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SectionHeader(icon: Icons.history, title: 'Alert history'),
        const SizedBox(height: 10),
        ...history.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              child: Row(
                children: <Widget>[
                  const Text('🚨', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${entry.vegetableName} ${entry.summary}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(entry.actualPriceLabel, style: Theme.of(context).textTheme.labelLarge),
                      Text(entry.whenLabel, style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCreateSheet(BuildContext context, AppController controller) {
    String vegetableName = controller.selectedVegetable.name;
    AlertComparison comparison = AlertComparison.above;
    final TextEditingController thresholdController =
        TextEditingController(text: '350');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Set price alert', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: vegetableName,
                    decoration: const InputDecoration(labelText: 'Vegetable'),
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
                      setSheetState(() => vegetableName = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    isSelected: <bool>[
                      comparison == AlertComparison.above,
                      comparison == AlertComparison.below,
                    ],
                    onPressed: (int index) {
                      setSheetState(
                        () => comparison = index == 0 ? AlertComparison.above : AlertComparison.below,
                      );
                    },
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('Price exceeds'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('Drops below'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: thresholdController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Threshold',
                      prefixText: 'Rs ',
                      suffixText: '/kg',
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppCard(
                    child: Row(
                      children: <Widget>[
                        const Text('🚨', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$vegetableName alert: ${comparison == AlertComparison.above ? 'Price hit' : 'Price dropped to'} Rs ${thresholdController.text}/kg',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            final double threshold = double.tryParse(thresholdController.text) ?? 0;
                            controller.addAlert(
                              AlertRule(
                                id: DateTime.now().millisecondsSinceEpoch,
                                vegetableName: vegetableName,
                                comparison: comparison,
                                threshold: threshold,
                                enabled: true,
                                createdLabel: 'Today',
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Create alert'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
