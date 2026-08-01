import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/alert_models.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/segmented_tab.dart';
import '../../../core/widgets/vegetable_avatar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final activeAlerts = controller.activeAlerts;
    final vegetable = controller.selectedVegetable;
    final history = controller.repository.alertHistoryFor(vegetable.name);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
          child: Row(
            children: <Widget>[
              Text(
                'Price alerts',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              _CreateAlertBtn(
                onTap: () => _openCreateSheet(context, controller),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader(
                icon: Icons.notifications_active,
                title:
                    'Active alerts (${activeAlerts.length})',
              ),
              const SizedBox(height: 12),
              ...controller.alerts.map(
                (alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    variant: alert.enabled
                        ? AppCardVariant.glow
                        : AppCardVariant.normal,
                    child: Row(
                      children: <Widget>[
                        VegetableAvatar(
                          name: alert.vegetableName,
                          color: controller.repository
                              .vegetableByName(alert.vegetableName)
                              .accentColor,
                          size: 48,
                          glow: alert.enabled,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                alert.vegetableName,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                alert.conditionLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Set on ${alert.createdLabel}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: alert.enabled,
                          onChanged: (_) =>
                              context.read<AppController>().toggleAlert(alert.id),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              SectionHeader(
                icon: Icons.history,
                title: 'Alert history',
              ),
              const SizedBox(height: 12),
              ...history.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              '🚨',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.text,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: entry.vegetableName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(text: ' ${entry.summary}'),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.success.withOpacity(0.22),
                                ),
                              ),
                              child: Text(
                                entry.actualPriceLabel,
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            entry.whenLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openCreateSheet(BuildContext context, AppController controller) {
    String vegetableName = controller.selectedVegetable.name;
    AlertComparison comparison = AlertComparison.above;
    final TextEditingController thresholdCtrl =
        TextEditingController(text: '350');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(
                top: BorderSide(color: AppColors.outlineStrong),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Set price alert',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.text : const Color(0xFF0F1F17),
                  ),
                ),
                const SizedBox(height: 14),

                // Veg selector
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: vegetableName,
                      isExpanded: true,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isDark ? AppColors.text : const Color(0xFF0F1F17),
                      ),
                      dropdownColor: isDark ? AppColors.surface2 : Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textMuted,
                      ),
                      items: controller.repository.vegetables
                          .map(
                            (v) => DropdownMenuItem<String>(
                              value: v.name,
                              child: Text(v.name),
                            ),
                          )
                          .toList(),
                      onChanged: (String? val) {
                        if (val == null) return;
                        setSheetState(() => vegetableName = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Condition tabs
                SegmentedTab(
                  options: const <String>['Price exceeds', 'Drops below'],
                  selected: comparison == AlertComparison.above
                      ? 'Price exceeds'
                      : 'Drops below',
                  onSelected: (v) => setSheetState(
                    () => comparison = v == 'Price exceeds'
                        ? AlertComparison.above
                        : AlertComparison.below,
                  ),
                ),
                const SizedBox(height: 12),

                // Threshold input
                TextField(
                  controller: thresholdCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setSheetState(() {}),
                  style: TextStyle(
                    color: isDark ? AppColors.text : const Color(0xFF0F1F17),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price threshold',
                    prefixText: 'Rs  ',
                    suffixText: '/kg',
                  ),
                ),
                const SizedBox(height: 12),

                // Preview
                AppCard(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: <Widget>[
                      const Text('🚨', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$vegetableName alert: '
                          '${comparison == AlertComparison.above ? 'Price hit' : 'Price dropped to'} '
                          'Rs ${thresholdCtrl.text}/kg '
                          '(your alert: Rs ${thresholdCtrl.text})',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () {
                          final double threshold =
                              double.tryParse(thresholdCtrl.text) ?? 0;
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
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.add_alert, size: 18),
                        label: const Text('Create alert'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CreateAlertBtn extends StatelessWidget {
  const _CreateAlertBtn({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppColors.amber, Color(0xFFE9651C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.amber.withOpacity(0.30),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add, size: 16, color: Color(0xFF1A0A00)),
            SizedBox(width: 4),
            Text(
              'Create alert',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A0A00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
