import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ViewModel que gerencia o tema da aplicação.
/// Persiste a escolha do usuário localmente.
class ThemeViewModel {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);

  /// Getter para o estado do tema.
  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  /// Inicializa o tema recuperando a preferência do usuário.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('app_theme');

    if (savedTheme == 'dark') {
      _themeMode.value = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode.value = ThemeMode.light;
    } else {
      _themeMode.value = ThemeMode.system;
    }
  }

  /// Alterna entre tema claro e escuro.
  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDark) {
      _themeMode.value = ThemeMode.dark;
      await prefs.setString('app_theme', 'dark');
    } else {
      _themeMode.value = ThemeMode.light;
      await prefs.setString('app_theme', 'light');
    }
  }
}
