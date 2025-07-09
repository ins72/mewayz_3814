import 'package:sizer/sizer.dart';

import '../core/accessibility_service.dart' hide HapticFeedbackType;
import '../core/app_export.dart';
import '../core/button_service.dart';
import '../theme/app_theme.dart';

class CustomEnhancedButtonWidget extends StatefulWidget {
  final String buttonId;
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool enableHaptic;
  final bool enableDebounce;
  final Duration? customDebounceDelay;
  final button_service.HapticFeedbackType hapticType;
  final bool isLoading;
  final Widget? loadingChild;
  final ButtonType buttonType;
  final bool isEnabled;

  const CustomEnhancedButtonWidget({
    Key? key,
    required this.buttonId,
    required this.onPressed,
    required this.child,
    this.style,
    this.enableHaptic = true,
    this.enableDebounce = true,
    this.customDebounceDelay,
    this.hapticType = button_service.HapticFeedbackType.lightImpact,
    this.isLoading = false,
    this.loadingChild,
    this.buttonType = ButtonType.elevated,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<CustomEnhancedButtonWidget> createState() => _CustomEnhancedButtonWidgetState();
}

class _CustomEnhancedButtonWidgetState extends State<CustomEnhancedButtonWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTap() {
    if (widget.isEnabled && !widget.isLoading) {
      ButtonService.handleButtonPress(
        widget.buttonId,
        widget.onPressed,
        enableHaptic: widget.enableHaptic,
        enableDebounce: widget.enableDebounce,
        customDebounceDelay: widget.customDebounceDelay,
        hapticType: widget.hapticType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: _buildButton(),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    final isDisabled = !widget.isEnabled || widget.isLoading;
    final buttonChild = widget.isLoading 
        ? (widget.loadingChild ?? _buildLoadingWidget()) 
        : widget.child;

    switch (widget.buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: isDisabled ? null : () {}, // Handled by GestureDetector
          style: widget.style ?? _getDefaultElevatedButtonStyle(isDisabled),
          child: buttonChild,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isDisabled ? null : () {}, // Handled by GestureDetector
          style: widget.style ?? _getDefaultOutlinedButtonStyle(isDisabled),
          child: buttonChild,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : () {}, // Handled by GestureDetector
          style: widget.style ?? _getDefaultTextButtonStyle(isDisabled),
          child: buttonChild,
        );
      case ButtonType.icon:
        return IconButton(
          onPressed: isDisabled ? null : () {}, // Handled by GestureDetector
          style: widget.style ?? _getDefaultIconButtonStyle(isDisabled),
          icon: buttonChild,
        );
    }
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      width: 4.w,
      height: 4.w,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.buttonType == ButtonType.elevated 
              ? AppTheme.primaryBackground 
              : AppTheme.primaryAction,
        ),
      ),
    );
  }

  ButtonStyle _getDefaultElevatedButtonStyle(bool isDisabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled 
          ? AppTheme.secondaryText.withAlpha(77)
          : AppTheme.primaryAction,
      foregroundColor: isDisabled
          ? AppTheme.secondaryText.withAlpha(153)
          : AppTheme.primaryBackground,
      elevation: isDisabled ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  ButtonStyle _getDefaultOutlinedButtonStyle(bool isDisabled) {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: isDisabled 
            ? AppTheme.secondaryText.withAlpha(77)
            : AppTheme.primaryAction,
        width: 1.5,
      ),
      foregroundColor: isDisabled
          ? AppTheme.secondaryText.withAlpha(153)
          : AppTheme.primaryAction,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  ButtonStyle _getDefaultTextButtonStyle(bool isDisabled) {
    return TextButton.styleFrom(
      foregroundColor: isDisabled
          ? AppTheme.secondaryText.withAlpha(153)
          : AppTheme.primaryAction,
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  ButtonStyle _getDefaultIconButtonStyle(bool isDisabled) {
    return IconButton.styleFrom(
      foregroundColor: isDisabled
          ? AppTheme.secondaryText.withAlpha(153)
          : AppTheme.primaryAction,
      padding: EdgeInsets.all(2.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
    );
  }
}

enum ButtonType {
  elevated,
  outlined,
  text,
  icon,
}