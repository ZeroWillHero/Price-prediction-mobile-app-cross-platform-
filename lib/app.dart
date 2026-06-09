import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/data/mock_market_repository.dart';
import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/app_shell.dart';

class VegePriceApp extends StatelessWidget {
  const VegePriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppController(MockMarketRepository()),
      child: Consumer<AppController>(
        builder: (context, controller, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'vege_price',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: controller.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
