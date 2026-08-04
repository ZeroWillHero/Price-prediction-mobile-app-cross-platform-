import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/locale_controller.dart';
import '../../../l10n/gen/app_localizations.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale _selected = const Locale('en');

  @override
  void initState() {
    super.initState();
    final Locale? current = context.read<LocaleController>().locale;
    if (current != null) {
      _selected = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              const Icon(Icons.eco, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                t.chooseLanguageTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                t.chooseLanguageSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _LanguageOption(
                label: t.languageEnglish,
                locale: const Locale('en'),
                selected: _selected,
                onSelect: (Locale locale) => setState(() => _selected = locale),
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                label: t.languageSinhala,
                locale: const Locale('si'),
                selected: _selected,
                onSelect: (Locale locale) => setState(() => _selected = locale),
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                label: t.languageTamil,
                locale: const Locale('ta'),
                selected: _selected,
                onSelect: (Locale locale) => setState(() => _selected = locale),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () async {
                  await context.read<LocaleController>().setLocale(_selected);
                  widget.onContinue?.call();
                },
                child: Text(t.continueButton, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.locale,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final Locale locale;
  final Locale selected;
  final ValueChanged<Locale> onSelect;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected.languageCode == locale.languageCode;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onSelect(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? scheme.primary : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? scheme.primary.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleLarge),
            ),
            if (isSelected) Icon(Icons.check_circle, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}
