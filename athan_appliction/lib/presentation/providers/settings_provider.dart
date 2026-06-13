import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import 'di_provider.dart';

final settingsProvider = ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends ChangeNotifier {
  final Ref ref;

  bool _isDarkMode = false;
  int _calculationMethod = 4; // Default to Umm Al-Qura (4)
  bool _is24HourFormat = false;

  bool get isDarkMode => _isDarkMode;
  int get calculationMethod => _calculationMethod;
  bool get is24HourFormat => _is24HourFormat;

  SettingsNotifier(this.ref) {
    _loadSettings();
  }

  void _loadSettings() {
    final prefs = ref.read(sharedPreferencesProvider);
    _isDarkMode = prefs.getBool(AppConstants.isDarkModeKey) ?? false;
    _calculationMethod = prefs.getInt(AppConstants.calculationMethodKey) ?? 4;
    _is24HourFormat = prefs.getBool(AppConstants.timeFormatKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.isDarkModeKey, value);
    notifyListeners();
  }

  Future<void> setCalculationMethod(int method) async {
    _calculationMethod = method;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(AppConstants.calculationMethodKey, method);
    notifyListeners();
  }

  Future<void> toggleTimeFormat(bool value) async {
    _is24HourFormat = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.timeFormatKey, value);
    notifyListeners();
  }
}
