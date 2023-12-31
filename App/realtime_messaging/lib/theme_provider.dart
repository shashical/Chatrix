import 'package:flutter/material.dart';
import 'package:realtime_messaging/main.dart';


class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = darkmode;

  // Future<void> loadThemePreference() async {
  //   String? themePreference = await FlutterSecureStorage().read(key: 'theme_preference');
  //   _isDarkMode = themePreference != null ? themePreference.toLowerCase() == 'true' : false;
  //   notifyListeners();
  // }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    // _saveThemePreference();
    notifyListeners();
  }

  // void _saveThemePreference() async {
  //   await FlutterSecureStorage().write(key: 'theme_preference', value: _isDarkMode.toString());
  // }
}
