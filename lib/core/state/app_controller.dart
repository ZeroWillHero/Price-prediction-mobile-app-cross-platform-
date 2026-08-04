import 'package:flutter/material.dart';

import '../data/api_market_repository.dart';
import '../models/alert_models.dart';
import '../models/vegetable_summary.dart';
import '../network/vege_predict_api.dart';

enum AppTab { home, predict, history, alerts, settings }

enum LoadState { loading, ready, error }

class AppController extends ChangeNotifier {
  AppController(this.repository);

  final ApiMarketRepository repository;

  LoadState _loadState = LoadState.loading;
  String? _errorMessage;

  AppTab _tab = AppTab.home;
  bool _isDarkMode = true;
  String _selectedVegetableId = '';
  String _selectedHorizon = '4W';
  List<AlertRule> _alerts = <AlertRule>[];

  LoadState get loadState => _loadState;
  String? get errorMessage => _errorMessage;

  AppTab get tab => _tab;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;
  String get selectedVegetableId => _selectedVegetableId;
  String get selectedHorizon => _selectedHorizon;
  List<AlertRule> get alerts => List<AlertRule>.unmodifiable(_alerts);
  List<AlertRule> get activeAlerts =>
      _alerts.where((AlertRule rule) => rule.enabled).toList(growable: false);

  VegetableSummary get selectedVegetable => repository.vegetableById(_selectedVegetableId);
  VegetableSummary get featuredVegetable => repository.featuredVegetable;

  Future<void> initialize() async {
    _loadState = LoadState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.load();
      _selectedVegetableId = repository.featuredVegetable.id;
      _alerts = repository.initialAlerts.map((AlertRule rule) => rule.copyWith()).toList(
            growable: true,
          );
      _loadState = LoadState.ready;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _loadState = LoadState.error;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      _loadState = LoadState.error;
    }
    notifyListeners();
  }

  void setTab(AppTab tab) {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
  }

  void selectVegetable(String id) {
    if (_selectedVegetableId == id) {
      return;
    }
    _selectedVegetableId = id;
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
