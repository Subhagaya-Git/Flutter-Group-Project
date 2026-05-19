import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color _lightPrimary = Color(0xFF111111);
  static const Color _lightBackground = Color(0xFFF4F6FA);
  static const Color _lightSurface = Colors.white;

  static const Color _darkPrimary = Color(0xFFFFD166);
  static const Color _darkBackground = Color(0xFF111315);
  static const Color _darkSurface = Color(0xFF1B1F24);

  static TextTheme _buildTextTheme(Color color) {
    return ThemeData.light().textTheme.apply(
          bodyColor: color,
          displayColor: color,
        );
  }

  static ColorScheme get _lightColorScheme {
    return const ColorScheme.light(
      primary: _lightPrimary,
      secondary: Color(0xFF5B6574),
      surface: _lightSurface,
      background: _lightBackground,
      error: Color(0xFFB42318),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightPrimary,
      onBackground: _lightPrimary,
      onError: Colors.white,
    );
  }

  static ColorScheme get _darkColorScheme {
    return const ColorScheme.dark(
      primary: _darkPrimary,
      secondary: Color(0xFF8AB4F8),
      surface: _darkSurface,
      background: _darkBackground,
      error: Color(0xFFF97066),
      onPrimary: _darkBackground,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: colorScheme.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        surfaceTintColor: _lightSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _lightPrimary),
        titleTextStyle: TextStyle(
          color: _lightPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(colorScheme.primary),
        trackColor: const WidgetStatePropertyAll<Color>(Color(0xFFD7DCE4)),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black.withOpacity(0.08),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: _lightPrimary,
        size: 24,
      ),
      textTheme: _buildTextTheme(_lightPrimary).copyWith(
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: colorScheme.onBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: colorScheme.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        surfaceTintColor: _darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(colorScheme.primary),
        trackColor: const WidgetStatePropertyAll<Color>(Color(0xFF3A3F47)),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.10),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      textTheme: _buildTextTheme(Colors.white).copyWith(
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: colorScheme.onBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
