import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
class AppTheme {
  AppTheme._();

  // Color specifications based on Sophisticated Dark Professional theme
  static const Color primaryBackground = Color(0xFF101010);
  static const Color surface = Color(0xFF191919);
  static const Color primaryAction = Color(0xFFFDFDFD);
  static const Color primaryText = Color(0xFFF1F1F1);
  static const Color secondaryText = Color(0xFF7B7B7B);
  static const Color accent = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color border = Color(0xFF282828);

  // Light theme colors (minimal light theme for system compatibility)
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1F2937);
  static const Color onSurfaceLight = Color(0xFF1F2937);

  // Shadow and elevation colors
  static const Color shadowDark = Color(0x1A000000);
  static const Color shadowLight = Color(0x0F000000);

  /// Dark theme (primary theme)
  static ThemeData darkTheme = ThemeData(
    
    colorScheme: const ColorScheme.dark(
      primary: primaryAction,
      secondary: accent,
    ),
    scaffoldBackgroundColor: primaryBackground,
    cardColor: surface,
    dividerColor: border,

    // AppBar theme with professional dark styling
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBackground,
      foregroundColor: primaryText,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: -0.2),
      iconTheme: const IconThemeData(
        color: primaryText,
        size: 24)),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: surface,
      elevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

    // Bottom navigation with professional styling
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primaryAction,
      unselectedItemColor: secondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400)),

    // Floating action button with gradient-like primary action
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryAction,
      foregroundColor: primaryBackground,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0))),

    // Button themes with professional styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryBackground,
        backgroundColor: primaryAction,
        elevation: 2,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1))),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1))),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1))),

    // Typography using Inter font family
    textTheme: _buildDarkTextTheme(),

    // Input decoration with professional dark styling
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surface,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: border, width: 1)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: border, width: 1)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: accent, width: 2)),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 2)),
      labelStyle: GoogleFonts.inter(
        color: secondaryText,
        fontSize: 16,
        fontWeight: FontWeight.w400),
      hintStyle: GoogleFonts.inter(
        color: secondaryText.withValues(alpha: 0.7),
        fontSize: 16,
        fontWeight: FontWeight.w400),
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w400)),

    // Switch theme with accent color
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryAction;
        }
        return secondaryText;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return border;
      })),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryAction),
      side: const BorderSide(color: border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4))),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return border;
      })),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
      circularTrackColor: border),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      thumbColor: primaryAction,
      overlayColor: accent.withValues(alpha: 0.2),
      inactiveTrackColor: border,
      valueIndicatorColor: accent,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryAction,
        fontSize: 12,
        fontWeight: FontWeight.w500)),

    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryText,
      unselectedLabelColor: secondaryText,
      indicatorColor: accent,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1)),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryText.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(
        color: primaryBackground,
        fontSize: 12,
        fontWeight: FontWeight.w400),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: GoogleFonts.inter(
        color: primaryText,
        fontSize: 14,
        fontWeight: FontWeight.w400),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)),
      elevation: 4),

    // List tile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accent.withValues(alpha: 0.1),
      iconColor: secondaryText,
      textColor: primaryText,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8))),

    // Drawer theme
    drawerTheme: DrawerThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16)))),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 16,
      shadowColor: shadowDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)))),

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: primaryText),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText)));

  /// Light theme (minimal implementation for system compatibility)
  static ThemeData lightTheme = ThemeData(
    
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: accent,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: onSurfaceLight.withValues(alpha: 0.12),
    textTheme: _buildLightTextTheme(),
    dialogTheme: DialogThemeData(backgroundColor: surfaceLight));

  /// Helper method to build dark text theme using Inter font
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: -0.25),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryText),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryText),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: -0.2),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: -0.15),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: -0.1),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.1),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.1),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.1),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0.15),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0.25),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        letterSpacing: 0.4),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.1),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
        letterSpacing: 0.5),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        letterSpacing: 0.5));
  }

  /// Helper method to build light text theme using Inter font
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: -0.25),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: -0.2),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: -0.15),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: -0.1),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: -0.1),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.1),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.1),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.15),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.25),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight.withValues(alpha: 0.6),
        letterSpacing: 0.4),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.1),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight.withValues(alpha: 0.6),
        letterSpacing: 0.5),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight.withValues(alpha: 0.6),
        letterSpacing: 0.5));
  }

  /// Data display text theme using JetBrains Mono for analytics and financial data
  static TextTheme get dataTextTheme => TextTheme(
        displayLarge: GoogleFonts.jetBrainsMono(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: primaryText,
          letterSpacing: -0.5),
        displayMedium: GoogleFonts.jetBrainsMono(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: primaryText,
          letterSpacing: -0.25),
        displaySmall: GoogleFonts.jetBrainsMono(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: primaryText),
        headlineLarge: GoogleFonts.jetBrainsMono(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: primaryText),
        headlineMedium: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryText),
        headlineSmall: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryText),
        titleLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryText),
        titleMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: primaryText),
        titleSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: primaryText),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: primaryText),
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: secondaryText),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryText),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: secondaryText),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: secondaryText));
}