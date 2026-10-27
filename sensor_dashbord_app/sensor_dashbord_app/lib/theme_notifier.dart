import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void updateThemeBasedOnLux(double lux) {
    if (lux < 80.0 && _themeMode != ThemeMode.dark) {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    } else if (lux >= 80.0 && _themeMode != ThemeMode.light) {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }
}
