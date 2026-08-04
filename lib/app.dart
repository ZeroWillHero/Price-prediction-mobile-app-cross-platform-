import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/data/api_market_repository.dart';
import 'core/state/app_controller.dart';
import 'core/state/auth_controller.dart';
import 'core/state/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/app_shell.dart';
import 'l10n/gen/app_localizations.dart';

class VegePriceApp extends StatelessWidget {
  const VegePriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AppController>(
          create: (_) => AppController(ApiMarketRepository())..initialize(),
        ),
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController()..load(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController()..restore(),
        ),
      ],
      child: Consumer3<AppController, LocaleController, AuthController>(
        builder: (context, appController, localeController, authController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Vege Price',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: appController.themeMode,
            locale: localeController.locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: AppShell(),
          );
        },
      ),
    );
  }
}
