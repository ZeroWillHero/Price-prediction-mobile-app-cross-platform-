import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/price_badge.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/vegetable_avatar.dart';
import '../../../l10n/gen/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenExplainability,
  });

  final VoidCallback onOpenExplainability;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final featured = controller.featuredVegetable;
    final trending = controller.repository.trendingVegetables;
    final AppLocalizations t = AppLocalizations.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _HomeHeader(
          onSettings: () =>
              context.read<AppController>().setTab(AppTab.settings),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Welcome
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 26),
                  children: <InlineSpan>[
                    TextSpan(
                      text: t.homeWelcomeBack,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(
                      text: 'Ravi ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  const Text(
                    '15 June 2026',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 10),
                  _PillBadge(
                    icon: Icons.wifi_tethering,
                    label: t.homeMarketStable,
                    color: AppColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Featured fire card
              AppCard(
                variant: AppCardVariant.fire,
                padding: EdgeInsets.zero,
                radius: 24,
                onTap: () {
                  context.read<AppController>().selectVegetable(featured.id);
                  context.read<AppController>().setTab(AppTab.predict);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        top: 12,
                        child: Center(
                          child: Text(
                            featured.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 90,
                              fontWeight: FontWeight.w900,
                              color: const Color(0x1506180E),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _PillBadge(
                                  icon: Icons.local_fire_department,
                                  label: t.homeBiggestMoverToday,
                                  color: const Color(0xFF06180E),
                                  bg: const Color(0x40FFFFFF),
                                ),
                                Text(
                                  _evoLabel(t, featured.changePercent),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF06180E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: _HeroChip(id: featured.id, size: 116),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      featured.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF06180E),
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatRs(featured.currentPrice),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF06180E),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xD2041209),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        featured.changePercent >= 0
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: const Color(0xFFFDB022),
                                        size: 18,
                                      ),
                                      Text(
                                        formatPercent(featured.changePercent),
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFFDB022),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Trending
              SectionHeader(
                icon: Icons.trending_up,
                title: t.homeTrendingThisWeek,
                actionLabel: t.seeAll,
              ),
              const SizedBox(height: 12),
              ...trending.map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      context.read<AppController>().selectVegetable(v.id);
                      context.read<AppController>().setTab(AppTab.predict);
                    },
                    child: Row(
                      children: <Widget>[
                        VegetableAvatar(
                          id: v.id,
                          color: v.accentColor,
                          size: 50,
                          glow: true,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                v.name,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatRs(v.currentPrice),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PriceBadge(
                          label: formatPercent(v.changePercent),
                          positive: v.changePercent >= 0,
                          trend: v.changePercent > 0
                              ? TrendDirection.up
                              : v.changePercent < 0
                                  ? TrendDirection.down
                                  : TrendDirection.flat,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Alerts
              SectionHeader(
                icon: Icons.notifications_active,
                title: t.homeActiveAlerts,
                actionLabel: t.manage,
                onAction: () =>
                    context.read<AppController>().setTab(AppTab.alerts),
              ),
              const SizedBox(height: 12),
              AppCard(
                variant: AppCardVariant.glow,
                onTap: () =>
                    context.read<AppController>().setTab(AppTab.alerts),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: <Color>[AppColors.amber, Color(0xFFE9651C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.amber.withOpacity(0.36),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.campaign,
                        size: 22,
                        color: Color(0xFF1A0F02),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            t.homeAlertsTriggeredToday(2),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.homeSampleAlertDetail,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Quick actions
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<AppController>().setTab(AppTab.history),
                      icon: const Icon(Icons.show_chart, size: 18),
                      label: Text(t.navHistory),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenExplainability,
                      icon: const Icon(Icons.account_tree, size: 18),
                      label: Text(t.howItWorks),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.16),
              border: Border.all(color: AppColors.accent.withOpacity(0.36)),
            ),
            child: const Center(
              child: Text('🌿', style: TextStyle(fontSize: 18)),
            ),
          ),
          const Spacer(),
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {},
                iconSize: 22,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSettings,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[AppColors.accent, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.icon,
    required this.label,
    required this.color,
    this.bg,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg ?? color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: bg != null ? null : Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.id, required this.size});

  final String id;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = vegImages[id];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x30FFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white.withOpacity(0.22),
            blurRadius: 30,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: imagePath != null
            ? SizedBox(
                width: size * 0.58,
                height: size * 0.58,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              )
            : Text(
                id.isNotEmpty ? id.substring(0, 1).toUpperCase() : '?',
                style: TextStyle(fontSize: size * 0.52),
              ),
      ),
    );
  }
}
