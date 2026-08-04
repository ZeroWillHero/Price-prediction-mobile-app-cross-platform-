import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_controller.dart';
import '../../../core/state/auth_controller.dart';
import '../../../core/state/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../explainability/presentation/explainability_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final LocaleController localeController = context.watch<LocaleController>();
    final AuthController authController = context.watch<AuthController>();
    final AppLocalizations t = AppLocalizations.of(context);
    final user = authController.user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text(t.settingsTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        AppCard(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                child: Text(user != null && user.firstName.isNotEmpty ? user.firstName[0] : 'U'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user?.fullName ?? 'User',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(user?.email ?? '', style: Theme.of(context).textTheme.bodySmall),
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
                label: t.settingsDarkMode,
                trailing: Switch(
                  value: controller.isDarkMode,
                  onChanged: (_) => context.read<AppController>().toggleTheme(),
                ),
              ),
              _SettingRow(
                icon: Icons.language,
                label: t.settingsLanguage,
                trailing: _LanguageDropdown(
                  value: localeController.locale ?? const Locale('en'),
                  onChanged: (Locale locale) =>
                      context.read<LocaleController>().setLocale(locale),
                ),
              ),
              _SettingRow(
                icon: Icons.wifi_off,
                label: t.settingsOfflineMode,
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
              _SettingRow(
                icon: Icons.notifications,
                label: t.settingsNotifications,
                trailing: Text(t.settingsNotificationsOn, style: Theme.of(context).textTheme.bodySmall),
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
                label: t.settingsHowPredictionsWork,
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
                label: t.settingsPrivacyData,
                trailing: const Icon(Icons.chevron_right),
                isLast: true,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        Text(
          t.appVersion,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({required this.value, required this.onChanged});

  final Locale value;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final Map<String, String> labels = <String, String>{
      'en': t.languageEnglish,
      'si': t.languageSinhala,
      'ta': t.languageTamil,
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value.languageCode,
        isDense: true,
        icon: const Icon(Icons.expand_more, size: 18),
        style: Theme.of(context).textTheme.bodySmall,
        items: labels.entries
            .map(
              (MapEntry<String, String> e) => DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value),
              ),
            )
            .toList(),
        onChanged: (String? code) {
          if (code == null) return;
          onChanged(Locale(code));
        },
      ),
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
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
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
