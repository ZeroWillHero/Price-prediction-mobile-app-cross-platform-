import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../alerts/presentation/alerts_screen.dart';
import '../../explainability/presentation/explainability_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../predict/presentation/predict_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../l10n/gen/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final AppLocalizations t = AppLocalizations.of(context);
    final List<Widget> pages = <Widget>[
      HomeScreen(onOpenExplainability: () => _openExplainability(context)),
      PredictScreen(onOpenExplainability: () => _openExplainability(context)),
      const HistoryScreen(),
      const AlertsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: controller.tab.index,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outline, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: controller.tab.index,
          onDestinationSelected: (int index) {
            context.read<AppController>().setTab(AppTab.values[index]);
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome),
              label: t.navPredict,
            ),
            NavigationDestination(
              icon: const Icon(Icons.show_chart_outlined),
              selectedIcon: const Icon(Icons.show_chart),
              label: t.navHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined),
              selectedIcon: const Icon(Icons.notifications),
              label: t.navAlerts,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: t.navSettings,
            ),
          ],
        ),
      ),
    );
  }

  void _openExplainability(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ExplainabilityScreen(),
      ),
    );
  }
}
