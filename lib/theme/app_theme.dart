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

  // Enhanced sizing constants for consistent responsive design
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXl = 32.0;

  // Button height constants
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 52.0;

  // Container min touch target size
  static const double minTouchTarget = 44.0;

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
      onError: primaryAction,
    ),
    scaffoldBackgroundColor: primaryBackground,
    cardColor: surface,
    dividerColor: divider,

    // Enhanced AppBar theme with consistent styling
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
        letterSpacing: -0.2,
      ),
      iconTheme: const IconThemeData(
        color: primaryText,
        size: iconSizeL,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actionsIconTheme: const IconThemeData(
        color: primaryText,
        size: iconSizeL,
      ),
      centerTitle: true,
      toolbarHeight: 60,
    ),

    // Enhanced Card theme with consistent spacing
    cardTheme: CardTheme(
      color: surface,
      elevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
    ),

    // Enhanced Bottom navigation with consistent sizing
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: secondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedIconTheme: const IconThemeData(size: iconSizeL),
      unselectedIconTheme: const IconThemeData(size: iconSizeM),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Enhanced Floating action button with consistent sizing
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: primaryAction,
      elevation: 6,
      focusElevation: 8,
      hoverElevation: 8,
      highlightElevation: 10,
      sizeConstraints: const BoxConstraints(
        minWidth: 56,
        minHeight: 56,
        maxWidth: 56,
        maxHeight: 56,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL),
      ),
    ),

    // Enhanced Button themes with consistent heights
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryAction,
        backgroundColor: accent,
        disabledForegroundColor: secondaryText,
        disabledBackgroundColor: surface,
        elevation: 2,
        shadowColor: shadowDark,
        minimumSize: const Size(0, buttonHeightM),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        disabledForegroundColor: secondaryText,
        minimumSize: const Size(0, buttonHeightM),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        disabledForegroundColor: secondaryText,
        minimumSize: const Size(0, buttonHeightM),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Enhanced Typography with consistent line heights
    textTheme: _buildDarkTextTheme(),

    // Enhanced Input decoration with consistent spacing
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceVariant,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingM,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: secondaryText,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      hintStyle: GoogleFonts.inter(
        color: secondaryText.withAlpha(179),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      helperStyle: GoogleFonts.inter(
        color: secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    ),

    // Enhanced Switch theme with consistent sizing
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
      overlayColor: WidgetStateProperty.all(accent.withAlpha(51)),
      splashRadius: 20,
    ),

    // Enhanced Checkbox theme with consistent sizing
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
        borderRadius: BorderRadius.circular(4),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),

    // Enhanced Radio theme with consistent sizing
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return border;
      }),
      overlayColor: WidgetStateProperty.all(accent.withAlpha(51)),
      splashRadius: 20,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),

    // Enhanced Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
      circularTrackColor: border,
      refreshBackgroundColor: surface,
    ),

    // Enhanced Slider theme with consistent styling
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      thumbColor: primaryAction,
      overlayColor: accent.withAlpha(51),
      inactiveTrackColor: border,
      valueIndicatorColor: accent,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryAction,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Enhanced Tab bar theme with consistent spacing
    tabBarTheme: TabBarTheme(
      labelColor: primaryText,
      unselectedLabelColor: secondaryText,
      indicatorColor: accent,
      indicatorSize: TabBarIndicatorSize.label,
      tabAlignment: TabAlignment.start,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: spacingM),
    ),

    // Enhanced Tooltip theme with consistent styling
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryText.withAlpha(242),
        borderRadius: BorderRadius.circular(radiusS),
      ),
      textStyle: GoogleFonts.inter(
        color: primaryBackground,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
      margin: const EdgeInsets.all(spacingS),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 2),
    ),

    // Enhanced SnackBar theme with consistent styling
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: GoogleFonts.inter(
        color: primaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      elevation: 4,
      insetPadding: const EdgeInsets.all(spacingM),
    ),

    // Enhanced List tile theme with consistent spacing
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accent.withAlpha(26),
      iconColor: secondaryText,
      textColor: primaryText,
      selectedColor: accent,
      minVerticalPadding: spacingS,
      horizontalTitleGap: spacingM,
      minLeadingWidth: 40,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryText,
        height: 1.4,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        height: 1.4,
      ),
      leadingAndTrailingTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondaryText,
        height: 1.4,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
      enableFeedback: true,
      visualDensity: VisualDensity.comfortable,
    ),

    // Enhanced Drawer theme with consistent styling
    drawerTheme: DrawerThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radiusL),
          bottomRight: Radius.circular(radiusL),
        ),
      ),
    ),

    // Enhanced Bottom sheet theme with consistent styling
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 16,
      shadowColor: shadowDark,
      modalBackgroundColor: surface,
      dragHandleColor: border,
      dragHandleSize: const Size(32, 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusXl),
          topRight: Radius.circular(radiusXl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
    ),

    // Enhanced Dialog theme with consistent styling
    dialogTheme: DialogTheme(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL),
      ),
      insetPadding: const EdgeInsets.all(spacingL),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
        height: 1.4,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        height: 1.4,
      ),
      actionsPadding: const EdgeInsets.all(spacingM),
    ),

    // Enhanced Chip theme with consistent styling
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      deleteIconColor: secondaryText,
      disabledColor: surface.withAlpha(128),
      selectedColor: accent.withAlpha(51),
      secondarySelectedColor: accent.withAlpha(26),
      padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
        height: 1.4,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: accent,
        height: 1.4,
      ),
      brightness: Brightness.dark,
      elevation: 0,
      pressElevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL),
      ),
      showCheckmark: true,
      checkmarkColor: accent,
    ),
  );

  /// Light theme (minimal implementation for system compatibility)
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: accent,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: onSurfaceLight.withAlpha(31),
    textTheme: _buildLightTextTheme(),
    dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
  );

  /// Helper method to build dark text theme using Inter font with consistent line heights
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to build light text theme using Inter font with consistent line heights
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data display text theme using JetBrains Mono for analytics and financial data
  static TextTheme get dataTextTheme => TextTheme(
        displayLarge: GoogleFonts.jetBrainsMono(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: primaryText,
          letterSpacing: -0.5,
          height: 1.25),
        displayMedium: GoogleFonts.jetBrainsMono(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: primaryText,
          letterSpacing: -0.25,
          height: 1.29),
        displaySmall: GoogleFonts.jetBrainsMono(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.33),
        headlineLarge: GoogleFonts.jetBrainsMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.4),
        headlineMedium: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.44),
        headlineSmall: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.5),
        titleLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.43),
        titleMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.33),
        titleSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.45),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.43),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.33),
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: secondaryText,
          height: 1.6),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: secondaryText,
          height: 1.33),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: secondaryText,
          height: 1.6),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: secondaryText,
          height: 1.56));

  /// Helper method to create consistent elevated container
  static BoxDecoration elevatedContainer({
    Color? color,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(radius ?? radiusM),
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth ?? 1)
          : null,
      boxShadow: shadows ??
          [
            BoxShadow(
              color: shadowDark,
              blurRadius: 8,
              offset: const Offset(0, 2)),
          ]);
  }

  /// Helper method to create consistent card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    double? radius,
    bool hasBorder = true,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(radius ?? radiusM),
      border: hasBorder
          ? Border.all(color: border.withAlpha(26), width: 1)
          : null,
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: shadowDark,
                blurRadius: 4,
                offset: const Offset(0, 2)),
            ]
          : null);
  }

  /// Helper method to create consistent button decoration
  static BoxDecoration buttonDecoration({
    Color? color,
    double? radius,
    bool isPressed = false,
    bool isDisabled = false,
  }) {
    return BoxDecoration(
      color: isDisabled
          ? surface
          : color ?? accent,
      borderRadius: BorderRadius.circular(radius ?? radiusM),
      boxShadow: isPressed || isDisabled
          ? null
          : [
              BoxShadow(
                color: (color ?? accent).withAlpha(77),
                blurRadius: 8,
                offset: const Offset(0, 4)),
            ]);
  }

  /// Helper method to create consistent input decoration
  static InputDecoration inputDecoration({
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      enabled: isEnabled,
      fillColor: isEnabled ? surfaceVariant : surface,
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: border.withAlpha(128), width: 1.5)));
  }
}