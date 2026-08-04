import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/dated_price.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/price_badge.dart';
import '../../../core/widgets/price_date_explorer.dart';
import '../../../core/widgets/segmented_tab.dart';
import '../../../core/widgets/vegetable_avatar.dart';
import '../../../l10n/gen/app_localizations.dart';

class PredictScreen extends StatelessWidget {
  const PredictScreen({
    super.key,
    required this.onOpenExplainability,
  });

  final VoidCallback onOpenExplainability;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final vegetable = controller.selectedVegetable;
    final forecast = controller.repository.forecastFor(
      vegetable.id,
      controller.selectedHorizon,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations t = AppLocalizations.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        _PredictHeader(onBack: null, title: t.navPredict),

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
                      child: vegImages[vegetable.id] != null
                          ? SizedBox(
                              width: 96,
                              height: 96,
                              child: Image.asset(
                                vegImages[vegetable.id]!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              vegetable.name.isNotEmpty
                                  ? vegetable.name.substring(0, 1)
                                  : '?',
                              style: const TextStyle(fontSize: 82),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Pill
                  _Pill(
                      label:
                          '${_evoLabel(t, vegetable.changePercent)} · ${t.livePriceSuffix}'),
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
                        label:
                            '${formatPercent(vegetable.changePercent)} ${t.todaySuffix}',
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
              Text(
                t.predictHorizonQuestion,
                style: const TextStyle(
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
              Row(
                children: <Widget>[
                  const Icon(Icons.info_outline,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(
                    t.predictLongerLessAccurate,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Browse the same prediction (or any other future date) —
              // past dates aren't offered here, only present week onward.
              PriceDateExplorer(
                points: _fromCurrentWeek(controller.repository.pricesFor(vegetable.id)),
                initialDate: DateTime.now().add(
                  Duration(days: 7 * _weeksFor(controller.selectedHorizon)),
                ),
              ),
              const SizedBox(height: 14),

              // About this prediction
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
                          t.predictionInfo,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _InfoStat(
                            icon: Icons.psychology,
                            color: AppColors.info,
                            value: modelFamilyLabel(forecast.modelFamily),
                            label: t.predictionMethod,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoStat(
                            icon: Icons.rule,
                            color: AppColors.success,
                            value:
                                'Rs ${forecast.typicalErrorRs.toStringAsFixed(0)}',
                            label: t.typicalAccuracy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: onOpenExplainability,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            t.seeHowModelWorks,
                            style: const TextStyle(
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
                      label: Text(t.share),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<AppController>().setTab(AppTab.history),
                      icon: const Icon(Icons.show_chart, size: 18),
                      label: Text(t.navHistory),
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

/// Drops every point before the current week, so the date picker only
/// offers the present week and future (predicted) dates — no history.
List<DatedPrice> _fromCurrentWeek(List<DatedPrice> points) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  return points.where((DatedPrice p) => !p.date.isBefore(startOfWeek)).toList();
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

String _evoLabel(AppLocalizations t, double change) {
  if (change >= 8) return t.evoFire;
  if (change >= 4) return t.evoHot;
  if (change >= 0) return t.evoMild;
  if (change >= -3) return t.evoCool;
  return t.evoCalm;
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _PredictHeader extends StatelessWidget {
  const _PredictHeader({required this.onBack, required this.title});

  final VoidCallback? onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          IconButton(
            icon:
                const Icon(Icons.help_outline, color: AppColors.textSecondary),
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
          const Icon(Icons.local_fire_department,
              size: 14, color: AppColors.accent),
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

String modelFamilyLabel(String modelFamily) {
  const Map<String, String> labels = <String, String>{
    'sarimax': 'SARIMAX',
    'lstm': 'LSTM',
    'random_forest': 'Random Forest',
    'xgboost': 'XGBoost',
    'catboost': 'CatBoost',
    'hybrid_xgboost_sarimax': 'Hybrid (XGBoost)',
    'hybrid_random_forest_sarimax': 'Hybrid (Random Forest)',
  };
  return labels[modelFamily] ?? modelFamily;
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

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
              color: color.withValues(alpha: 0.16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.text : const Color(0xFF0F1F17),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
