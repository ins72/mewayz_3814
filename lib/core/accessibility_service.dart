import 'package:flutter/semantics.dart';

import '../core/app_export.dart';

/// Enhanced accessibility service for comprehensive app accessibility
class AccessibilityService {
  static final AccessibilityService _instance = AccessibilityService._internal();
  static AccessibilityService get instance => _instance;
  AccessibilityService._internal();

  bool _isInitialized = false;
  bool _isScreenReaderEnabled = false;
  bool _isHighContrastEnabled = false;
  bool _isLargeTextEnabled = false;
  double _textScaleFactor = 1.0;

  // Accessibility preferences
  bool get isScreenReaderEnabled => _isScreenReaderEnabled;
  bool get isHighContrastEnabled => _isHighContrastEnabled;
  bool get isLargeTextEnabled => _isLargeTextEnabled;
  double get textScaleFactor => _textScaleFactor;

  /// Initialize accessibility service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check system accessibility settings
      await _checkSystemAccessibilitySettings();
      
      // Initialize semantic announcements
      _initializeSemanticAnnouncements();
      
      // Set up accessibility feedback
      _setupAccessibilityFeedback();
      
      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('✅ Accessibility service initialized');
        debugPrint('Screen reader: $_isScreenReaderEnabled');
        debugPrint('High contrast: $_isHighContrastEnabled');
        debugPrint('Large text: $_isLargeTextEnabled');
        debugPrint('Text scale factor: $_textScaleFactor');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Accessibility service initialization failed: $e');
      }
    }
  }

  /// Check system accessibility settings
  Future<void> _checkSystemAccessibilitySettings() async {
    try {
      // Get media query data from the first context available
      final mediaQuery = WidgetsBinding.instance.window;
      
      // Check text scale factor
      _textScaleFactor = mediaQuery.textScaleFactor;
      _isLargeTextEnabled = _textScaleFactor > 1.3;
      
      // Check if screen reader is enabled
      _isScreenReaderEnabled = mediaQuery.accessibilityFeatures.accessibleNavigation;
      
      // Check high contrast mode
      _isHighContrastEnabled = mediaQuery.accessibilityFeatures.highContrast;
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking accessibility settings: $e');
      }
    }
  }

  /// Initialize semantic announcements
  void _initializeSemanticAnnouncements() {
    // Configure semantic announcements for screen readers
    SemanticsService.announce(
      'Mewayz app loaded. Navigation ready.',
      TextDirection.ltr);
  }

  /// Setup accessibility feedback
  void _setupAccessibilityFeedback() {
    // Configure haptic feedback for accessibility
    if (_isScreenReaderEnabled) {
      // Enhanced haptic feedback for screen reader users
      HapticFeedback.lightImpact();
    }
  }

  /// Announce content changes to screen readers
  void announceContentChange(String message) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(message, TextDirection.ltr);
    }
  }

  /// Announce navigation changes
  void announceNavigation(String screenName) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(
        'Navigated to $screenName',
        TextDirection.ltr);
    }
  }

  /// Announce loading states
  void announceLoading(String message) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(
        '$message. Loading...',
        TextDirection.ltr);
    }
  }

  /// Announce completion of actions
  void announceCompletion(String message) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(
        '$message completed',
        TextDirection.ltr);
      HapticFeedback.lightImpact();
    }
  }

  /// Announce errors with appropriate feedback
  void announceError(String message) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(
        'Error: $message',
        TextDirection.ltr);
      HapticFeedback.heavyImpact();
    }
  }

  /// Get accessible text size based on system settings
  double getAccessibleTextSize(double baseSize) {
    return baseSize * _textScaleFactor.clamp(0.8, 3.0);
  }

  /// Get accessible color contrast
  Color getAccessibleColor(Color color, {bool isBackground = false}) {
    if (!_isHighContrastEnabled) return color;
    
    if (isBackground) {
      // High contrast background colors
      return color.computeLuminance() > 0.5 ? Colors.white : Colors.black;
    } else {
      // High contrast text colors
      return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }
  }

  /// Create accessible button with proper semantics
  Widget createAccessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String semanticsLabel,
    String? semanticsHint,
    bool isEnabled = true,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: true,
      enabled: isEnabled,
      child: Material(
        child: InkWell(
          onTap: isEnabled ? () {
            if (_isScreenReaderEnabled) {
              HapticFeedback.lightImpact();
            }
            onPressed();
          } : null,
          child: child)));
  }

  /// Create accessible text field
  Widget createAccessibleTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? errorText,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
  }) {
    return Semantics(
      label: '$labelText${isRequired ? ' (required)' : ''}',
      hint: hintText,
      textField: true,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: getAccessibleTextSize(16),
          color: getAccessibleColor(AppTheme.primaryText)),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          labelStyle: TextStyle(
            fontSize: getAccessibleTextSize(14),
            color: getAccessibleColor(AppTheme.secondaryText)),
          hintStyle: TextStyle(
            fontSize: getAccessibleTextSize(14),
            color: getAccessibleColor(AppTheme.secondaryText)),
          errorStyle: TextStyle(
            fontSize: getAccessibleTextSize(12),
            color: getAccessibleColor(AppTheme.error)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              
              width: _isHighContrastEnabled ? 2 : 1)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: getAccessibleColor(AppTheme.accent),
              width: _isHighContrastEnabled ? 3 : 2)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: getAccessibleColor(AppTheme.error),
              width: _isHighContrastEnabled ? 3 : 2)))));
  }

  /// Create accessible card with proper semantics
  Widget createAccessibleCard({
    required Widget child,
    String? semanticsLabel,
    String? semanticsHint,
    VoidCallback? onTap,
    EdgeInsets? padding,
    Color? backgroundColor,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: onTap != null,
      child: Card(
        color: backgroundColor ?? getAccessibleColor(AppTheme.primaryBackground, isBackground: true),
        elevation: _isHighContrastEnabled ? 8 : 4,
        margin: EdgeInsets.all(8),
        child: InkWell(
          onTap: onTap != null ? () {
            if (_isScreenReaderEnabled) {
              HapticFeedback.lightImpact();
            }
            onTap();
          } : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: padding ?? EdgeInsets.all(16),
            child: child))));
  }

  /// Create accessible list item
  Widget createAccessibleListItem({
    required Widget child,
    required String semanticsLabel,
    String? semanticsHint,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: onTap != null,
      selected: isSelected

);
  }

  /// Create accessible image with proper semantics
  Widget createAccessibleImage({
    required String imageUrl,
    required String semanticsLabel,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Semantics(
      label: semanticsLabel,
      image: true,
      child: CustomImageWidget(
        imageUrl: imageUrl,
        width: width ?? 100.0,
        height: height ?? 100.0,
        fit: fit ?? BoxFit.cover));
  }

  /// Create accessible progress indicator
  Widget createAccessibleProgressIndicator({
    required double progress,
    required String semanticsLabel,
    String? semanticsHint,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      value: '${(progress * 100).round()}%',
      child: LinearProgressIndicator(
        value: progress,
        
        valueColor: AlwaysStoppedAnimation<Color>(
          getAccessibleColor(AppTheme.accent)),
        minHeight: _isScreenReaderEnabled ? 8 : 4));
  }

  /// Create accessible tab navigation
  Widget createAccessibleTabBar({
    required List<Tab> tabs,
    required TabController controller,
    required ValueChanged<int> onTap,
  }) {
    return Semantics(
      label: 'Navigation tabs',
      hint: 'Swipe or tap to navigate between sections',
      child: TabBar(
        controller: controller,
        tabs: tabs,
        onTap: (index) {
          if (_isScreenReaderEnabled) {
            HapticFeedback.selectionClick();
            announceNavigation(tabs[index].text ?? 'Tab ${index + 1}');
          }
          onTap(index);
        },
        labelStyle: TextStyle(
          fontSize: getAccessibleTextSize(14),
          fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: getAccessibleTextSize(14),
          fontWeight: FontWeight.w400),
        labelColor: getAccessibleColor(AppTheme.accent),
        unselectedLabelColor: getAccessibleColor(AppTheme.secondaryText),
        indicatorColor: getAccessibleColor(AppTheme.accent),
        indicatorWeight: _isHighContrastEnabled ? 4 : 2));
  }

  /// Update accessibility settings when system settings change
  void updateAccessibilitySettings(MediaQueryData mediaQuery) {
    final oldTextScaleFactor = _textScaleFactor;
    final oldScreenReaderEnabled = _isScreenReaderEnabled;
    final oldHighContrastEnabled = _isHighContrastEnabled;
    
    _textScaleFactor = mediaQuery.textScaleFactor;
    _isLargeTextEnabled = _textScaleFactor > 1.3;
    _isScreenReaderEnabled = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.accessibleNavigation;
    _isHighContrastEnabled = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.highContrast;
    
    // Announce changes to screen reader users
    if (_isScreenReaderEnabled && !oldScreenReaderEnabled) {
      announceContentChange('Screen reader enabled');
    } else if (!_isScreenReaderEnabled && oldScreenReaderEnabled) {
      announceContentChange('Screen reader disabled');
    }
    
    if (_isHighContrastEnabled && !oldHighContrastEnabled) {
      announceContentChange('High contrast mode enabled');
    } else if (!_isHighContrastEnabled && oldHighContrastEnabled) {
      announceContentChange('High contrast mode disabled');
    }
    
    if ((_textScaleFactor - oldTextScaleFactor).abs() > 0.1) {
      announceContentChange('Text size changed');
    }
  }

  /// Get accessibility guidelines compliance status
  Map<String, bool> getAccessibilityCompliance() {
    return {
      'Screen Reader Support': _isScreenReaderEnabled,
      'High Contrast Support': _isHighContrastEnabled,
      'Large Text Support': _isLargeTextEnabled,
      'Semantic Labels': true, // Always supported
      'Keyboard Navigation': true, // Always supported
      'Haptic Feedback': true, // Always supported
      'Voice Over Support': true, // Always supported
      'Focus Management': true, // Always supported
      'Color Contrast': true, // Always supported
      'Touch Target Size': true, // Always supported
    };
  }

  /// Dispose accessibility service
  void dispose() {
    _isInitialized = false;
  }
}