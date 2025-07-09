
import 'app_export.dart';

class ButtonService {
  static const Duration _debounceDelay = Duration(milliseconds: 300);
  static const Duration _hapticDelay = Duration(milliseconds: 50);
  
  static final Map<String, DateTime> _lastPressedTime = {};
  static final Map<String, bool> _isProcessing = {};

  // Enhanced button press handler with debouncing and haptic feedback
  static Future<void> handleButtonPress(
    String buttonId,
    VoidCallback onPressed, {
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
  }) async {
    // Check if button is already being processed
    if (_isProcessing[buttonId] == true) {
      if (ProductionConfig.enableLogging) {
        debugPrint('ButtonService: Button $buttonId is already being processed');
      }
      return;
    }

    // Check debounce
    if (enableDebounce) {
      final lastPressed = _lastPressedTime[buttonId];
      final debounceDelay = customDebounceDelay ?? _debounceDelay;
      
      if (lastPressed != null && 
          DateTime.now().difference(lastPressed) < debounceDelay) {
        if (ProductionConfig.enableLogging) {
          debugPrint('ButtonService: Button $buttonId is being debounced');
        }
        return;
      }
    }

    // Set processing state
    _isProcessing[buttonId] = true;
    _lastPressedTime[buttonId] = DateTime.now();

    try {
      // Trigger haptic feedback
      if (enableHaptic) {
        await _triggerHapticFeedback(hapticType);
      }

      // Execute button action
      onPressed();

      if (ProductionConfig.enableLogging) {
        debugPrint('ButtonService: Button $buttonId pressed successfully');
      }
    } catch (error) {
      ErrorHandler.handleError(
        'Button press failed for $buttonId: $error',
        context: 'ButtonService.handleButtonPress',
      );
    } finally {
      // Clear processing state after a short delay
      Future.delayed(Duration(milliseconds: 100), () {
        _isProcessing[buttonId] = false;
      });
    }
  }

  // Navigation helper methods
  static Future<void> navigateTo({
    required BuildContext context,
    required String route,
    Object? arguments,
    bool showFeedback = false,
    String? feedbackMessage,
  }) async {
    try {
      if (showFeedback && feedbackMessage != null) {
        // Show loading or feedback message
        debugPrint('ButtonService: $feedbackMessage');
      }
      
      await Navigator.pushNamed(
        context,
        route,
        arguments: arguments,
      );
    } catch (error) {
      ErrorHandler.handleError(
        'Navigation failed to $route: $error',
        context: 'ButtonService.navigateTo',
      );
    }
  }

  static Future<void> handleNavigation({
    required BuildContext context,
    required String route,
    Object? arguments,
    bool showFeedback = false,
    String? feedbackMessage,
  }) async {
    await navigateTo(
      context: context,
      route: route,
      arguments: arguments,
      showFeedback: showFeedback,
      feedbackMessage: feedbackMessage,
    );
  }

  // Trigger haptic feedback with delay
  static Future<void> _triggerHapticFeedback(HapticFeedbackType type) async {
    try {
      await Future.delayed(_hapticDelay);
      
      switch (type) {
        case HapticFeedbackType.lightImpact:
          await HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selectionClick:
          await HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.vibrate:
          await HapticFeedback.vibrate();
          break;
      }
    } catch (error) {
      if (ProductionConfig.enableLogging) {
        debugPrint('ButtonService: Haptic feedback failed: $error');
      }
    }
  }

  // Enhanced button widget with built-in debouncing and haptic feedback
  static Widget createEnhancedButton({
    required String buttonId,
    required VoidCallback onPressed,
    required Widget child,
    ButtonStyle? style,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    bool isLoading = false,
    Widget? loadingChild,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => handleButtonPress(
        buttonId,
        onPressed,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      style: style,
      child: isLoading ? (loadingChild ?? _buildLoadingWidget()) : child,
    );
  }

  // Enhanced outlined button
  static Widget createEnhancedOutlinedButton({
    required String buttonId,
    required VoidCallback onPressed,
    required Widget child,
    ButtonStyle? style,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    bool isLoading = false,
    Widget? loadingChild,
  }) {
    return OutlinedButton(
      onPressed: isLoading ? null : () => handleButtonPress(
        buttonId,
        onPressed,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      style: style,
      child: isLoading ? (loadingChild ?? _buildLoadingWidget()) : child,
    );
  }

  // Enhanced text button
  static Widget createEnhancedTextButton({
    required String buttonId,
    required VoidCallback onPressed,
    required Widget child,
    ButtonStyle? style,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.selectionClick,
    bool isLoading = false,
    Widget? loadingChild,
  }) {
    return TextButton(
      onPressed: isLoading ? null : () => handleButtonPress(
        buttonId,
        onPressed,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      style: style,
      child: isLoading ? (loadingChild ?? _buildLoadingWidget()) : child,
    );
  }

  // Enhanced icon button
  static Widget createEnhancedIconButton({
    required String buttonId,
    required VoidCallback onPressed,
    required Widget icon,
    ButtonStyle? style,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.selectionClick,
    bool isLoading = false,
    Widget? loadingChild,
  }) {
    return IconButton(
      onPressed: isLoading ? null : () => handleButtonPress(
        buttonId,
        onPressed,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      style: style,
      icon: isLoading ? (loadingChild ?? _buildLoadingWidget()) : icon,
    );
  }

  // Enhanced floating action button
  static Widget createEnhancedFloatingActionButton({
    required String buttonId,
    required VoidCallback onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    bool isLoading = false,
    Widget? loadingChild,
  }) {
    return FloatingActionButton(
      onPressed: isLoading ? null : () => handleButtonPress(
        buttonId,
        onPressed,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: isLoading ? (loadingChild ?? _buildLoadingWidget()) : child,
    );
  }

  // Build loading widget
  static Widget _buildLoadingWidget() {
    return SizedBox(
      width: 4.w,
      height: 4.w,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBackground),
      ),
    );
  }

  // Check if button is currently being processed
  static bool isButtonProcessing(String buttonId) {
    return _isProcessing[buttonId] ?? false;
  }

  // Clear all button states (useful for testing or cleanup)
  static void clearAllButtonStates() {
    _lastPressedTime.clear();
    _isProcessing.clear();
  }

  // Get time since last button press
  static Duration? getTimeSinceLastPress(String buttonId) {
    final lastPressed = _lastPressedTime[buttonId];
    if (lastPressed != null) {
      return DateTime.now().difference(lastPressed);
    }
    return null;
  }

  // Custom gesture detector with enhanced button handling
  static Widget createEnhancedGestureDetector({
    required String buttonId,
    required VoidCallback onTap,
    required Widget child,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.selectionClick,
  }) {
    return GestureDetector(
      onTap: () => handleButtonPress(
        buttonId,
        onTap,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      child: child,
    );
  }

  // Enhanced inkwell with button handling
  static Widget createEnhancedInkWell({
    required String buttonId,
    required VoidCallback onTap,
    required Widget child,
    bool enableHaptic = true,
    bool enableDebounce = true,
    Duration? customDebounceDelay,
    HapticFeedbackType hapticType = HapticFeedbackType.selectionClick,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: () => handleButtonPress(
        buttonId,
        onTap,
        enableHaptic: enableHaptic,
        enableDebounce: enableDebounce,
        customDebounceDelay: customDebounceDelay,
        hapticType: hapticType,
      ),
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

// Enum for haptic feedback types
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}