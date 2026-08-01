import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/trend_point.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/mini_line_chart.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/segmented_tab.dart';
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
    final controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final history = controller.repository.historyFor(vegetable.name);
    final stats = _buildStats(history);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
          child: Row(
            children: <Widget>[
              Text(
                'Price history',
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
                      name: vegetable.name,
                      color: vegetable.accentColor,
                      size: 44,
                      glow: true,
                    ),
                    const SizedBox(width: 12),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: vegetable.name,
                        isExpanded: false,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
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
                          context.read<AppController>().selectVegetable(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Range tabs
              SegmentedTab(
                options: const <String>['1M', '3M', '6M', '1Y', 'All'],
                selected: _range,
                onSelected: (r) => setState(() => _range = r),
              ),
              const SizedBox(height: 14),

              // Stats 2x2
              Row(
                children: <Widget>[
                  Expanded(
                    child: StatCard(
                      icon: Icons.arrow_downward,
                      label: 'Min price',
                      value: 'Rs ${stats.min.toStringAsFixed(0)}',
                      subLabel: stats.minLabel,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.arrow_upward,
                      label: 'Max price',
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

              // Chart card with crisis overlay
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.30,
                      top: 20,
                      bottom: 36,
                      right: MediaQuery.of(context).size.width * 0.24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.danger.withOpacity(0.18),
                          ),
                        ),
                      ),
                    ),
                    ForecastLineChart(
                      actual: history,
                      xgboost: const <TrendPoint>[],
                      hybrid: const <TrendPoint>[],
                      labels: const <String>[
                        'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
                        'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Legend
              Wrap(
                spacing: 18,
                runSpacing: 8,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.28),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Crisis period',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.cloud, size: 14, color: AppColors.info),
                      SizedBox(width: 6),
                      Text(
                        'Weather alert',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Crisis events
              SectionHeader(
                icon: Icons.warning_amber_rounded,
                title: 'Crisis events',
              ),
              const SizedBox(height: 12),
              ...controller.repository.eventsFor(vegetable.name).map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        padding: const EdgeInsets.all(13),
                        child: Row(
                          children: <Widget>[
                            Text(event.emoji, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  Text(
                                    event.period,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.danger.withOpacity(0.22),
                                ),
                              ),
                              child: Text(
                                event.deltaLabel,
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 8),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('Export as PDF'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _HistoryStats _buildStats(List<TrendPoint> history) {
    final List<double> values =
        history.map((TrendPoint p) => p.value).toList();
    final double min =
        values.reduce((double a, double b) => a < b ? a : b);
    final double max =
        values.reduce((double a, double b) => a > b ? a : b);
    final double avg =
        values.fold<double>(0, (double s, double v) => s + v) / values.length;
    final double variance = values.fold<double>(
          0,
          (double s, double v) => s + (v - avg) * (v - avg),
        ) /
        values.length;
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
