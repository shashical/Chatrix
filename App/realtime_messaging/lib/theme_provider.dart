import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

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
