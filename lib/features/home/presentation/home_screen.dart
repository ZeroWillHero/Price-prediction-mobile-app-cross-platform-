import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_controller.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/mini_line_chart.dart';
import '../../../core/widgets/price_badge.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/vegetable_avatar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenExplainability,
  });

  final VoidCallback onOpenExplainability;

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final featured = controller.featuredVegetable;
    final trending = controller.repository.trendingVegetables;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Welcome back, Ravi', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('15 June 2026', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.notifications_outlined),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          onTap: () {
            context.read<AppController>().selectVegetable(featured.name);
            context.read<AppController>().setTab(AppTab.predict);
          },
          padding: const EdgeInsets.all(18),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Chip(label: Text('Biggest mover today')),
                  const Spacer(),
                  Text(
                    featured.changePercent >= 0 ? 'Uptrend' : 'Downtrend',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Center(
                child: VegetableAvatar(
                  name: featured.name,
                  color: featured.accentColor,
                  size: 100,
                ),
              ),
              const SizedBox(height: 14),
              Text(featured.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Text(formatRs(featured.currentPrice), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 10),
                  PriceBadge(
                    label: featured.changePercent >= 0
                        ? '+${featured.changePercent.toStringAsFixed(0)}%'
                        : '${featured.changePercent.toStringAsFixed(0)}%',
                    positive: featured.changePercent >= 0,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                featured.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(icon: Icons.trending_up, title: 'Trending this week'),
        const SizedBox(height: 10),
        ...trending.map(
          (vegetable) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () {
                context.read<AppController>().selectVegetable(vegetable.name);
                context.read<AppController>().setTab(AppTab.predict);
              },
              child: Row(
                children: <Widget>[
                  VegetableAvatar(name: vegetable.name, color: vegetable.accentColor, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          vegetable.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(formatRs(vegetable.currentPrice), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: MiniLineChart(series: vegetable.sparkline, color: vegetable.accentColor),
                  ),
                  const SizedBox(width: 8),
                  PriceBadge(
                    label: vegetable.changePercent >= 0
                        ? '+${vegetable.changePercent.toStringAsFixed(0)}%'
                        : '${vegetable.changePercent.toStringAsFixed(0)}%',
                    positive: vegetable.changePercent >= 0,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SectionHeader(
          icon: Icons.notifications,
          title: 'Active alerts',
          actionLabel: 'Manage',
          onAction: () => context.read<AppController>().setTab(AppTab.alerts),
        ),
        const SizedBox(height: 10),
        AppCard(
          onTap: () => context.read<AppController>().setTab(AppTab.alerts),
          child: Row(
            children: <Widget>[
              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('2 alerts triggered today\nCarrot hit Rs 350/kg'),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(icon: Icons.flash_on, title: 'Quick actions'),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton(
                onPressed: () {
                  context.read<AppController>().selectVegetable(controller.repository.vegetables.first.name);
                  context.read<AppController>().setTab(AppTab.predict);
                },
                child: const Text('Predict prices'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.read<AppController>().setTab(AppTab.history),
                child: const Text('History'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onOpenExplainability,
          child: const Text('How it works'),
        ),
      ],
    );
  }
}
