import 'package:flutter/material.dart';

import '../data/mock_market_repository.dart';
import '../models/alert_models.dart';
import '../models/vegetable_summary.dart';

enum AppTab { home, predict, history, alerts, settings }

class AppController extends ChangeNotifier {
  AppController(this.repository)
      : _selectedVegetableName = repository.featuredVegetable.name,
        _alerts = repository.initialAlerts
            .map((AlertRule rule) => rule.copyWith())
            .toList(growable: true);

  final MockMarketRepository repository;

  AppTab _tab = AppTab.home;
  bool _isDarkMode = true;
  String _selectedVegetableName;
  String _selectedHorizon = '4W';
  final List<AlertRule> _alerts;

  AppTab get tab => _tab;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;
  String get selectedVegetableName => _selectedVegetableName;
  String get selectedHorizon => _selectedHorizon;
  List<AlertRule> get alerts => List<AlertRule>.unmodifiable(_alerts);
  List<AlertRule> get activeAlerts =>
      _alerts.where((AlertRule rule) => rule.enabled).toList(growable: false);

  VegetableSummary get selectedVegetable =>
      repository.vegetableByName(_selectedVegetableName);
  VegetableSummary get featuredVegetable => repository.featuredVegetable;

  void setTab(AppTab tab) {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
  }

  void selectVegetable(String name) {
    if (_selectedVegetableName == name) {
      return;
    }
    _selectedVegetableName = name;
    notifyListeners();
  }

  void setHorizon(String horizon) {
    if (_selectedHorizon == horizon) {
      return;
    }
    _selectedHorizon = horizon;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleAlert(int id) {
    final int index = _alerts.indexWhere((AlertRule rule) => rule.id == id);
    if (index == -1) {
      return;
    }
    _alerts[index] = _alerts[index].copyWith(enabled: !_alerts[index].enabled);
    notifyListeners();
  }

  void addAlert(AlertRule alert) {
    _alerts.add(alert);
    notifyListeners();
  }
}
