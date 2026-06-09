import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_controller.dart';
import '../../../core/widgets/app_card.dart';
import '../../explainability/presentation/explainability_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        AppCard(
          child: Row(
            children: <Widget>[
              const CircleAvatar(radius: 26, child: Text('R')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Ravi Perera', style: Theme.of(context).textTheme.titleLarge),
                    Text('Farmer · Kandy District', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.dark_mode,
                label: 'Dark mode',
                trailing: Switch(
                  value: controller.isDarkMode,
                  onChanged: (_) => context.read<AppController>().toggleTheme(),
                ),
              ),
              _SettingRow(
                icon: Icons.language,
                label: 'Language',
                trailing: Text('English · සිංහල', style: Theme.of(context).textTheme.bodySmall),
              ),
              _SettingRow(
                icon: Icons.wifi_off,
                label: 'Offline mode',
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
              _SettingRow(
                icon: Icons.notifications,
                label: 'Notifications',
                trailing: Text('On', style: Theme.of(context).textTheme.bodySmall),
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.psychology,
                label: 'How predictions work',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const ExplainabilityScreen(),
                    ),
                  );
                },
              ),
              _SettingRow(
                icon: Icons.shield,
                label: 'Privacy & data',
                trailing: const Icon(Icons.chevron_right),
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'vege_price v1.0.0',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        trailing,
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 12, 10, isLast ? 12 : 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
        ),
        child: row,
      ),
    );
  }
}
