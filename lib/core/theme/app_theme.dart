import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark(useMaterial3: true);
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surfaceDark,
    background: AppColors.backgroundDark,
    error: AppColors.danger,
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineLarge,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineMedium,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineSmall,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: base.textTheme.titleLarge,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: base.textTheme.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: base.textTheme.titleSmall,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outlineDark, width: 1),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: const Color(0xFF16261F),
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: Colors.white),
      side: const BorderSide(color: AppColors.outlineDark),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? AppColors.primary
            : const Color(0xFF74857B),
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? AppColors.primary.withOpacity(0.35)
            : const Color(0xFF2A372F),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outlineDark),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primary.withOpacity(0.22),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surfaceLight,
    background: Colors.white,
    error: AppColors.danger,
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineLarge,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineMedium,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: base.textTheme.headlineSmall,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: base.textTheme.titleLarge,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: base.textTheme.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: base.textTheme.titleSmall,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outlineLight, width: 1),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: Colors.black),
      side: const BorderSide(color: AppColors.outlineLight),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outlineLight),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.primary.withOpacity(0.12),
    ),
  );
}
