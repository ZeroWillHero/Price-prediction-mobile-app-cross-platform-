import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/dated_price.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/price_date_explorer.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/vegetable_avatar.dart';
import '../../../l10n/gen/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final List<DatedPrice> prices =
        controller.repository.pricesFor(vegetable.id);
    final stats = _historyStats(prices);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations t = AppLocalizations.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
          child: Row(
            children: <Widget>[
              Text(
                t.historyTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              _IconBtn(
                icon: Icons.download,
                onTap: () {},
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Veg selector
              AppCard(
                padding: const EdgeInsets.all(12),
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    VegetableAvatar(
                      id: vegetable.id,
                      color: vegetable.accentColor,
                      size: 44,
                      glow: true,
                    ),
                    const SizedBox(width: 12),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: vegetable.id,
                        isExpanded: false,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color:
                              isDark ? AppColors.text : const Color(0xFF0F1F17),
                        ),
                        dropdownColor:
                            isDark ? AppColors.surface2 : Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textMuted,
                        ),
                        items: controller.repository.vegetables
                            .map(
                              (v) => DropdownMenuItem<String>(
                                value: v.id,
                                child: Text(v.name),
                              ),
                            )
                            .toList(),
                        onChanged: (String? val) {
                          if (val == null) return;
                          context.read<AppController>().selectVegetable(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Pick any date and see its recorded or predicted price
              PriceDateExplorer(points: prices),
              const SizedBox(height: 18),

              // Stats 2x2
              Row(
                children: <Widget>[
                  Expanded(
                    child: StatCard(
                      icon: Icons.arrow_downward,
                      label: t.minPrice,
                      value: 'Rs ${stats.min.toStringAsFixed(0)}',
                      subLabel: stats.minLabel,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.arrow_upward,
                      label: t.maxPrice,
                      value: 'Rs ${stats.max.toStringAsFixed(0)}',
                      subLabel: stats.maxLabel,
                      color: AppColors.danger,
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
                      label: t.average,
                      value: 'Rs ${stats.avg.toStringAsFixed(0)}',
                      subLabel: t.thisPeriod,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.show_chart,
                      label: t.volatility,
                      value: 'Rs ${stats.volatility.toStringAsFixed(0)}',
                      subLabel: t.stdDev,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

_HistoryStats _historyStats(List<DatedPrice> prices) {
  final List<DatedPrice> recorded =
      prices.where((DatedPrice p) => !p.isPredicted).toList();
  final List<double> values = recorded.map((DatedPrice p) => p.price).toList();
  if (values.isEmpty) {
    return const _HistoryStats(
        min: 0, max: 0, avg: 0, volatility: 0, minLabel: '', maxLabel: '');
  }
  final DatedPrice minPoint = recorded.reduce(
    (DatedPrice a, DatedPrice b) => a.price < b.price ? a : b,
  );
  final DatedPrice maxPoint = recorded.reduce(
    (DatedPrice a, DatedPrice b) => a.price > b.price ? a : b,
  );
  final double avg =
      values.fold<double>(0, (double s, double v) => s + v) / values.length;
  final double variance = values.fold<double>(
        0,
        (double s, double v) => s + (v - avg) * (v - avg),
      ) /
      values.length;
  return _HistoryStats(
    min: minPoint.price,
    max: maxPoint.price,
    avg: avg,
    volatility: math.sqrt(variance),
    minLabel: DateFormat('d MMM').format(minPoint.date),
    maxLabel: DateFormat('d MMM').format(maxPoint.date),
  );
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

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
