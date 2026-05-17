import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary brand color — purple matching reference featured card
  static const Color primary = Color(0xFF7C5CBF);
  static const Color primaryContainer = Color(0xFFEDE7F6);
  static const Color secondary = Color(0xFF4FC3F7);

  // Semantic colors
  static const Color success = Color(0xFF2D7A4F);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFB91C1C);

  // Accent palette
  static const Color accentYellow = Color(0xFFF5C842);
  static const Color accentOrange = Color(0xFFF5A623);
  static const Color accentPink = Color(0xFFE91E8C);
  static const Color accentBlue = Color(0xFF4FC3F7);
  static const Color accentPurple = Color(0xFF7C5CBF);

  // Light surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5F4FA);
  static const Color backgroundLight = Color(0xFFF0EFF8);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E1A2E);
  static const Color backgroundDark = Color(0xFF13101F);

  // Nav bar
  static const Color navBarDark = Color(0xFF1A1A2E);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF2D1B69),
      secondary: secondary,
      onSecondary: Colors.white,
      surface: surfaceLight,
      onSurface: Color(0xFF1A1A2E),
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: Color(0xFF6B6B8A),
      error: error,
      onError: Colors.white,
      outline: Color(0xFFD0CDE8),
      outlineVariant: Color(0xFFEAE8F5),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
      titleLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      titleMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      titleSmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1A1A2E),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF4A4A6A),
      ),
      bodySmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Color(0xFF6B6B8A),
      ),
      labelLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      labelSmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: Color(0xFF6B6B8A),
      ),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: backgroundLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: const InputDecorationThemeData(
      filled: false,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD0CDE8), width: 1.5),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD0CDE8), width: 1.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
      labelStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B6B8A),
      ),
      hintStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB0ADCC),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF3D2B7A),
      onPrimaryContainer: Color(0xFFEDE7F6),
      secondary: secondary,
      onSecondary: Colors.white,
      surface: surfaceDark,
      onSurface: Color(0xFFE6E2F5),
      surfaceContainerHighest: Color(0xFF2A2440),
      onSurfaceVariant: Color(0xFFB0ADCC),
      error: Color(0xFFCF6679),
      onError: Colors.white,
      outline: Color(0xFF3A3560),
      outlineVariant: Color(0xFF2A2440),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE6E2F5),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE6E2F5),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE6E2F5),
      ),
      titleLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE6E2F5),
      ),
      titleMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE6E2F5),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Color(0xFFE6E2F5),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB0ADCC),
      ),
      bodySmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8A87AA),
      ),
      labelLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE6E2F5),
      ),
      labelSmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: Color(0xFF8A87AA),
      ),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: backgroundDark,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}