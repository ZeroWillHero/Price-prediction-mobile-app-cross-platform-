import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('si'),
  Locale('ta'),
];

class LocaleController extends ChangeNotifier {
  static const String _prefsKey = 'app_locale_code';

  Locale? _locale;
  bool _isLoading = true;

  Locale? get locale => _locale;
  bool get isLoading => _isLoading;
  bool get hasChosenLanguage => _locale != null;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_prefsKey);
    if (code != null) {
      _locale = supportedLocales.firstWhere(
        (Locale locale) => locale.languageCode == code,
        orElse: () => supportedLocales.first,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}
