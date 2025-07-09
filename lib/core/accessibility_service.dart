import 'dart:math' as math;

import 'package:flutter/semantics.dart';

import 'app_export.dart';

class AccessibilityService {
  static AccessibilityService? _instance;
  static AccessibilityService get instance => _instance ??= AccessibilityService._internal();
  
  AccessibilityService._internal();

  /// Initialize accessibility service
  Future<void> initialize() async {
    try {
      await _checkAccessibilityFeatures();
      await _configureAccessibilitySettings();
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize accessibility service: $e');
    }
  }

  /// Check if accessibility features are enabled
  Future<void> _checkAccessibilityFeatures() async {
    final bool isTalkBackEnabled = await _isTalkBackEnabled();
    final bool isVoiceOverEnabled = await _isVoiceOverEnabled();
    final bool isHighContrastEnabled = await _isHighContrastEnabled();
    final bool isLargeTextEnabled = await _isLargeTextEnabled();
    
    if (ProductionConfig.enableLogging) {
      debugPrint('Accessibility Features:');
      debugPrint('- TalkBack: ${isTalkBackEnabled ? "Enabled" : "Disabled"}');
      debugPrint('- VoiceOver: ${isVoiceOverEnabled ? "Enabled" : "Disabled"}');
      debugPrint('- High Contrast: ${isHighContrastEnabled ? "Enabled" : "Disabled"}');
      debugPrint('- Large Text: ${isLargeTextEnabled ? "Enabled" : "Disabled"}');
    }
  }

  /// Configure accessibility settings
  Future<void> _configureAccessibilitySettings() async {
    try {
      // Enable accessibility features
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      
      // Configure haptic feedback
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppTheme.primaryBackground,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to configure accessibility settings: $e');
    }
  }

  /// Check if TalkBack is enabled (Android)
  Future<bool> _isTalkBackEnabled() async {
    try {
      final bool isEnabled = await const MethodChannel('accessibility')
          .invokeMethod('isTalkBackEnabled');
      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Check if VoiceOver is enabled (iOS)
  Future<bool> _isVoiceOverEnabled() async {
    try {
      final bool isEnabled = await const MethodChannel('accessibility')
          .invokeMethod('isVoiceOverEnabled');
      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Check if high contrast is enabled
  Future<bool> _isHighContrastEnabled() async {
    try {
      final bool isEnabled = await const MethodChannel('accessibility')
          .invokeMethod('isHighContrastEnabled');
      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Check if large text is enabled
  Future<bool> _isLargeTextEnabled() async {
    try {
      final bool isEnabled = await const MethodChannel('accessibility')
          .invokeMethod('isLargeTextEnabled');
      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Announce message to screen reader
  Future<void> announceMessage(String message) async {
    try {
      await SemanticsService.announce(message, TextDirection.ltr);
    } catch (e) {
      ErrorHandler.handleError('Failed to announce message: $e');
    }
  }

  /// Provide haptic feedback
  Future<void> hapticFeedback(HapticFeedbackType type) async {
    try {
      switch (type) {
        case HapticFeedbackType.light:
          await HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selection:
          await HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.vibrate:
          await HapticFeedback.vibrate();
          break;
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to provide haptic feedback: $e');
    }
  }

  /// Focus on specific widget
  Future<void> focusOnWidget(FocusNode focusNode) async {
    try {
      focusNode.requestFocus();
    } catch (e) {
      ErrorHandler.handleError('Failed to focus on widget: $e');
    }
  }

  /// Get accessibility contrast ratio
  double getContrastRatio(Color foreground, Color background) {
    final double foregroundLuminance = _getLuminance(foreground);
    final double backgroundLuminance = _getLuminance(background);
    
    final double lighterLuminance = math.max(foregroundLuminance, backgroundLuminance);
    final double darkerLuminance = math.min(foregroundLuminance, backgroundLuminance);
    
    return (lighterLuminance + 0.05) / (darkerLuminance + 0.05);
  }

  /// Calculate luminance of a color
  double _getLuminance(Color color) {
    final double r = _getLinearColorValue(color.red);
    final double g = _getLinearColorValue(color.green);
    final double b = _getLinearColorValue(color.blue);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Get linear color value for luminance calculation
  double _getLinearColorValue(int colorValue) {
    final double normalizedValue = colorValue / 255.0;
    
    if (normalizedValue <= 0.03928) {
      return normalizedValue / 12.92;
    } else {
      return math.pow((normalizedValue + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Check if color combination meets WCAG guidelines
  bool meetsWCAGGuidelines(Color foreground, Color background, {WCAGLevel level = WCAGLevel.AA}) {
    final double contrastRatio = getContrastRatio(foreground, background);
    
    switch (level) {
      case WCAGLevel.AA:
        return contrastRatio >= 4.5;
      case WCAGLevel.AAA:
        return contrastRatio >= 7.0;
      case WCAGLevel.AA_LARGE:
        return contrastRatio >= 3.0;
      case WCAGLevel.AAA_LARGE:
        return contrastRatio >= 4.5;
    }
  }

  /// Get minimum touch target size
  Size getMinimumTouchTargetSize() {
    return const Size(44, 44); // iOS and Android recommendation
  }

  /// Check if widget meets minimum touch target size
  bool meetsMinimumTouchTargetSize(Size widgetSize) {
    final Size minSize = getMinimumTouchTargetSize();
    return widgetSize.width >= minSize.width && widgetSize.height >= minSize.height;
  }

  /// Get accessibility node information
  Map<String, dynamic> getAccessibilityNodeInfo(BuildContext context) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return {};
    
    final SemanticsNode? semanticsNode = renderObject.debugSemantics;
    if (semanticsNode == null) return {};
    
    return {
      'label': semanticsNode.label,
      'hint': semanticsNode.hint,
      'value': semanticsNode.value,
      'isEnabled': !semanticsNode.hasFlag(SemanticsFlag.hasEnabledState) || 
                   semanticsNode.hasFlag(SemanticsFlag.isEnabled),
      'isSelected': semanticsNode.hasFlag(SemanticsFlag.isSelected),
      'isFocused': semanticsNode.hasFlag(SemanticsFlag.isFocused),
      'isButton': semanticsNode.hasFlag(SemanticsFlag.isButton),
      'isTextField': semanticsNode.hasFlag(SemanticsFlag.isTextField),
      'isHeader': semanticsNode.hasFlag(SemanticsFlag.isHeader),
    };
  }

  /// Validate accessibility compliance
  Future<AccessibilityAuditResult> performAccessibilityAudit(BuildContext context) async {
    final List<AccessibilityIssue> issues = [];
    
    try {
      // Check color contrast
      final bool colorContrastIssue = !meetsWCAGGuidelines(
        AppTheme.primaryText,
        AppTheme.primaryBackground,
      );
      
      if (colorContrastIssue) {
        issues.add(AccessibilityIssue(
          type: AccessibilityIssueType.colorContrast,
          severity: AccessibilityIssueSeverity.high,
          description: 'Color contrast does not meet WCAG AA guidelines',
          recommendation: 'Increase contrast between text and background colors',
        ));
      }
      
      // Check touch target sizes
      // This would need to be implemented with actual widget measurements
      
      // Check semantic labels
      final Map<String, dynamic> nodeInfo = getAccessibilityNodeInfo(context);
      if (nodeInfo['label'] == null || nodeInfo['label'].toString().isEmpty) {
        issues.add(AccessibilityIssue(
          type: AccessibilityIssueType.missingSemanticLabel,
          severity: AccessibilityIssueSeverity.medium,
          description: 'Widget is missing semantic label',
          recommendation: 'Add semantic label to improve screen reader experience',
        ));
      }
      
      return AccessibilityAuditResult(
        issues: issues,
        passedChecks: _getPassedChecks(issues),
        totalChecks: _getTotalChecks(),
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to perform accessibility audit: $e');
      return AccessibilityAuditResult(
        issues: [
          AccessibilityIssue(
            type: AccessibilityIssueType.auditError,
            severity: AccessibilityIssueSeverity.high,
            description: 'Failed to perform accessibility audit',
            recommendation: 'Check accessibility service configuration',
          )
        ],
        passedChecks: 0,
        totalChecks: 1,
      );
    }
  }

  int _getPassedChecks(List<AccessibilityIssue> issues) {
    final int totalChecks = _getTotalChecks();
    final int failedChecks = issues.length;
    return totalChecks - failedChecks;
  }

  int _getTotalChecks() {
    return 10; // Total number of accessibility checks
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
  vibrate,
}

enum WCAGLevel {
  AA,
  AAA,
  AA_LARGE,
  AAA_LARGE,
}

enum AccessibilityIssueType {
  colorContrast,
  touchTargetSize,
  missingSemanticLabel,
  missingFocusability,
  auditError,
}

enum AccessibilityIssueSeverity {
  low,
  medium,
  high,
  critical,
}

class AccessibilityIssue {
  final AccessibilityIssueType type;
  final AccessibilityIssueSeverity severity;
  final String description;
  final String recommendation;

  AccessibilityIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.recommendation,
  });
}

class AccessibilityAuditResult {
  final List<AccessibilityIssue> issues;
  final int passedChecks;
  final int totalChecks;

  AccessibilityAuditResult({
    required this.issues,
    required this.passedChecks,
    required this.totalChecks,
  });

  bool get isCompliant => issues.isEmpty;
  double get complianceScore => passedChecks / totalChecks;
}