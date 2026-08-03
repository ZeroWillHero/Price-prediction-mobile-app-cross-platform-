import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/forecast_models.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/mini_line_chart.dart';
import '../../../core/widgets/price_badge.dart';
import '../../../core/widgets/segmented_tab.dart';
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
    final controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final forecast = controller.repository.forecastFor(
      vegetable.name,
      controller.selectedHorizon,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        _PredictHeader(onBack: null),

        // Hero section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Watermark
              Positioned(
                left: 35,
                top: 0,
                child: Text(
                  vegetable.name,
                  style: GoogleFonts.poppins(
                    fontSize: 84,
                    fontWeight: FontWeight.w900,
                    color: isDark
                        ? const Color(0x0DE2EDE7)
                        : const Color(0x0A0F1F17),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  // Glow chip
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.accent.withOpacity(0.06)
                          : AppColors.accent.withOpacity(0.08),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.18),
                          blurRadius: 50,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: vegImages[vegetable.name] != null
                          ? SizedBox(
                              width: 96,
                              height: 96,
                              child: Image.asset(
                                vegImages[vegetable.name]!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              vegetable.name.isNotEmpty ? vegetable.name.substring(0, 1) : '?',
                              style: const TextStyle(fontSize: 82),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Pill
                  _Pill(label: '${_evoLabel(vegetable.changePercent)} · live price'),
                  const SizedBox(height: 10),
                  // Name
                  Text(
                    vegetable.name,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.text : const Color(0xFF0F1F17),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        formatRs(vegetable.currentPrice),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      PriceBadge(
                        label: '${formatPercent(vegetable.changePercent)} today',
                        positive: vegetable.changePercent >= 0,
                        trend: vegetable.changePercent > 0
                            ? TrendDirection.up
                            : TrendDirection.down,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vegetable.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Horizon
              const Text(
                'How far ahead do you want to predict?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              SegmentedTab(
                options: const <String>['1W', '2W', '4W', '8W', '12W'],
                selected: controller.selectedHorizon,
                onSelected: (h) => context.read<AppController>().setHorizon(h),
              ),
              const SizedBox(height: 8),
              const Row(
                children: <Widget>[
                  Icon(Icons.info_outline, size: 13, color: AppColors.textMuted),
                  SizedBox(width: 5),
                  Text(
                    'Longer forecasts are less accurate.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Predict button
              FilledButton.icon(
                onPressed: _loading
                    ? null
                    : () {
                        setState(() {
                          _loading = true;
                          _showResult = false;
                        });
                        Timer(const Duration(milliseconds: 1100), () {
                          if (!mounted) return;
                          setState(() {
                            _loading = false;
                            _showResult = true;
                          });
                        });
                      },
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF06180E),
                        ),
                      )
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(_loading ? 'Predicting…' : 'Predict now'),
              ),

              if (_showResult) ...<Widget>[
                const SizedBox(height: 18),

                // Prediction card
                AppCard(
                  variant: AppCardVariant.glow,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Predicted price · ${controller.selectedHorizon}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatRs(forecast.predictedPrice),
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expected range: Rs ${forecast.lowPrice.toStringAsFixed(0)} – Rs ${forecast.highPrice.toStringAsFixed(0)} (80% confidence)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Chart card
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ForecastLineChart(
                        actual: forecast.actualSeries,
                        xgboost: forecast.chronosSeries,
                        hybrid: forecast.hybridSeries,
                        labels: const <String>[
                          'W1', 'W2', 'W3', 'W4', 'W5', 'W6',
                          'W7', 'W8', 'W9', 'W10', 'W11', 'W12',
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: const <Widget>[
                          _ChartLegend(
                            color: AppColors.chartActual,
                            label: 'Actual',
                          ),
                          _ChartLegend(
                            color: AppColors.chartChronos,
                            label: 'XGBoost',
                            dashed: true,
                          ),
                          _ChartLegend(
                            color: AppColors.chartHybrid,
                            label: 'Hybrid',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Influence card
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.account_tree,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'What influenced this prediction?',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: forecast.influences
                            .map(
                              (f) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: _InfluenceCard(factor: f),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: widget.onOpenExplainability,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'See how the model works',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
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
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Share'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.read<AppController>().setTab(AppTab.history),
                        icon: const Icon(Icons.show_chart, size: 18),
                        label: const Text('History'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

String _evoLabel(double change) {
  if (change >= 8) return 'Fire';
  if (change >= 4) return 'Hot';
  if (change >= 0) return 'Mild';
  if (change >= -3) return 'Cool';
  return 'Calm';
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _PredictHeader extends StatelessWidget {
  const _PredictHeader({required this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Row(
        children: <Widget>[
          Text(
            'Predict',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textSecondary),
            onPressed: () {},
            iconSize: 22,
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.local_fire_department, size: 14, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 18,
          child: Divider(
            color: color,
            thickness: dashed ? 1.5 : 2.5,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _InfluenceCard extends StatelessWidget {
  const _InfluenceCard({required this.factor});

  final InfluenceFactor factor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceSunk : AppColors.bgLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.outline : AppColors.outlineLight,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: factor.color.withOpacity(0.16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: factor.color.withOpacity(0.28),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(factor.icon, color: factor.color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            factor.weightLabel,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.text : const Color(0xFF0F1F17),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            factor.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
