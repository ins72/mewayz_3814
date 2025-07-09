import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

/// A class that contains all theme configurations for the application.
class AppTheme {
  AppTheme._();

  // Color specifications based on Sophisticated Dark Professional theme
  static const Color primaryBackground = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color primaryAction = Color(0xFFFDFDFD);
  static const Color primaryText = Color(0xFFF5F5F5);
  static const Color secondaryText = Color(0xFF9CA3AF);
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentVariant = Color(0xFF1E40AF);
  static const Color success = Color(0xFF10B981);
  static const Color successVariant = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningVariant = Color(0xFFD97706);
  static const Color error = Color(0xFFEF4444);
  static const Color errorVariant = Color(0xFFDC2626);
  static const Color border = Color(0xFF374151);
  static const Color divider = Color(0xFF1F2937);

  // Enhanced gradients for modern design
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentVariant]);

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, primaryBackground]);

  // Light theme colors (minimal light theme for system compatibility)
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1F2937);
  static const Color onSurfaceLight = Color(0xFF1F2937);

  // Enhanced shadow and elevation colors
  static const Color shadowDark = Color(0x40000000);
  static const Color shadowLight = Color(0x1A000000);

  // Spacing constants for consistent layout
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border radius constants
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 24.0;

  /// Dark theme (primary theme)
  static ThemeData darkTheme = ThemeData(
    
    colorScheme: const ColorScheme.dark(
      primary: primaryAction,
      secondary: accent,
      surface: surface,
      error: error,
      onPrimary: primaryBackground,
      onSecondary: primaryAction,
      onSurface: primaryText,
      onError: primaryAction),
    scaffoldBackgroundColor: primaryBackground,
    cardColor: surface,
    dividerColor: divider,

    // Enhanced AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBackground,
      foregroundColor: primaryText,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.2),
      iconTheme: const IconThemeData(
        color: primaryText,
        size: 24),
      systemOverlayStyle: SystemUiOverlayStyle.light),

    // Enhanced Card theme
    cardTheme: CardTheme(
      color: surface,
      elevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
        side: BorderSide(
          color: border.withAlpha(26),
          width: 1)),
      margin: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS)),

    // Enhanced Bottom navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: secondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5)),

    // Enhanced Floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: primaryAction,
      elevation: 6,
      focusElevation: 8,
      hoverElevation: 8,
      highlightElevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL))),

    // Enhanced Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryAction,
        backgroundColor: accent,
        disabledForegroundColor: secondaryText,
        disabledBackgroundColor: surface,
        elevation: 2,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1))),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        disabledForegroundColor: secondaryText,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1))),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        disabledForegroundColor: secondaryText,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1))),

    // Enhanced Typography
    textTheme: _buildDarkTextTheme(),

    // Enhanced Input decoration
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceVariant,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingM),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: border, width: 1.5)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: border, width: 1.5)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: accent, width: 2)),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: error, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: error, width: 2)),
      labelStyle: GoogleFonts.inter(
        color: secondaryText,
        fontSize: 16,
        fontWeight: FontWeight.w500),
      hintStyle: GoogleFonts.inter(
        color: secondaryText.withAlpha(179),
        fontSize: 16,
        fontWeight: FontWeight.w400),
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w500)),

    // Enhanced Switch theme
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
      }),
      overlayColor: WidgetStateProperty.all(accent.withAlpha(51))),

    // Enhanced Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryAction),
      side: BorderSide(color: border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4))),

    // Enhanced Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return border;
      }),
      overlayColor: WidgetStateProperty.all(accent.withAlpha(51))),

    // Enhanced Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
      circularTrackColor: border),

    // Enhanced Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      thumbColor: primaryAction,
      overlayColor: accent.withAlpha(51),
      inactiveTrackColor: border,
      valueIndicatorColor: accent,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryAction,
        fontSize: 12,
        fontWeight: FontWeight.w600)),

    // Enhanced Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryText,
      unselectedLabelColor: secondaryText,
      indicatorColor: accent,
      indicatorSize: TabBarIndicatorSize.label,
      
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1)),

    // Enhanced Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryText.withAlpha(242),
        borderRadius: BorderRadius.circular(radiusS)),
      textStyle: GoogleFonts.inter(
        color: primaryBackground,
        fontSize: 12,
        fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS)),

    // Enhanced SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: GoogleFonts.inter(
        color: primaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM)),
      elevation: 4),

    // Enhanced List tile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accent.withAlpha(26),
      iconColor: secondaryText,
      textColor: primaryText,
      selectedColor: accent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryText),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS))),

    // Enhanced Drawer theme
    drawerTheme: DrawerThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radiusL),
          bottomRight: Radius.circular(radiusL)))),

    // Enhanced Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 16,
      shadowColor: shadowDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusXl),
          topRight: Radius.circular(radiusXl)))),

    // Enhanced Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText)));

  /// Light theme (minimal implementation for system compatibility)
  static ThemeData lightTheme = ThemeData(
    
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: accent),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: onSurfaceLight.withAlpha(31),
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
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.2),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.15),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.1),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: -0.1),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0.1),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0.1),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryText,
        letterSpacing: 0.5),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
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
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: -0.2),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: -0.15),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: -0.1),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: -0.1),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.1),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.4),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.1),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.5),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight.withAlpha(153),
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
          fontWeight: FontWeight.w600,
          color: primaryText),
        headlineMedium: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText),
        headlineSmall: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryText),
        titleLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryText),
        titleMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primaryText),
        titleSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
          fontWeight: FontWeight.w500,
          color: secondaryText),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: secondaryText),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: secondaryText));
}