import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.accent,
    onPrimary: Color(0xFF06180E),
    primaryContainer: AppColors.primary,
    onPrimaryContainer: AppColors.accent,
    secondary: AppColors.amber,
    onSecondary: Color(0xFF1A0A00),
    secondaryContainer: Color(0xFF3D2800),
    onSecondaryContainer: AppColors.amber,
    tertiary: AppColors.info,
    onTertiary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    surfaceContainerHighest: AppColors.surface2,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineStrong,
    scrim: Colors.black,
    shadow: Colors.black,
    inverseSurface: AppColors.text,
    onInverseSurface: AppColors.bg,
    inversePrimary: AppColors.primaryDark,
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: _textTheme(base.textTheme, AppColors.text, AppColors.textSecondary, AppColors.textMuted),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outline),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? AppColors.accent : AppColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AppColors.accent.withOpacity(0.28)
            : AppColors.surface2,
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outline),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: AppColors.accent.withOpacity(0.16),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
        color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.textMuted,
        size: 22,
      )),
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.textMuted,
      )),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: const Color(0xFF06180E),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        minimumSize: const Size(0, 46),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      prefixStyle: const TextStyle(color: AppColors.textSecondary),
      suffixStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surface2,
      selectedColor: AppColors.accent.withOpacity(0.20),
      labelStyle: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 13),
      side: const BorderSide(color: AppColors.outline),
      shape: const StadiumBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: AppColors.textSecondary,
      selectedColor: AppColors.accent,
      fillColor: AppColors.accent.withOpacity(0.14),
      borderColor: AppColors.outline,
      selectedBorderColor: AppColors.accent.withOpacity(0.45),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.light,
  ).copyWith(
    surface: AppColors.surfaceLight,
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bgLight,
    textTheme: _textTheme(
      base.textTheme,
      const Color(0xFF0F1F17),
      const Color(0xFF3D5C4A),
      const Color(0xFF7A9A86),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outlineLight),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.outlineLight),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.accent.withOpacity(0.12),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0F1F17),
        side: const BorderSide(color: AppColors.outlineLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        minimumSize: const Size(0, 46),
        elevation: 0,
      ),
    ),
  );
}

TextTheme _textTheme(TextTheme base, Color text, Color secondary, Color muted) {
  return base.copyWith(
    displayLarge: GoogleFonts.poppins(fontSize: 56, fontWeight: FontWeight.w800, color: text),
    displayMedium: GoogleFonts.poppins(fontSize: 44, fontWeight: FontWeight.w800, color: text),
    displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w800, color: text),
    headlineLarge: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: text),
    headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: text),
    headlineSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: text),
    titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: text),
    titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: text),
    titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: text),
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: secondary, height: 1.6),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: secondary, height: 1.55),
    bodySmall: GoogleFonts.inter(fontSize: 12, color: muted, height: 1.5),
    labelLarge: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: text),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
    labelSmall: GoogleFonts.inter(fontSize: 11, color: muted),
  );
}
