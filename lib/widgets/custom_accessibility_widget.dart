import '../core/app_export.dart';

/// Custom accessibility widget with enhanced features
class CustomAccessibilityWidget extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final String? semanticsValue;
  final bool isButton;
  final bool isTextField;
  final bool isImage;
  final bool isHeader;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool excludeSemantics;

  const CustomAccessibilityWidget({
    Key? key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.semanticsValue,
    this.isButton = false,
    this.isTextField = false,
    this.isImage = false,
    this.isHeader = false,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
    this.onLongPress,
    this.excludeSemantics = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    final accessibilityService = AccessibilityService.instance;

    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      value: semanticsValue,
      button: isButton,
      textField: isTextField,
      image: isImage,
      header: isHeader,
      selected: isSelected,
      enabled: isEnabled,
      onTap: onTap != null ? () {
        if (accessibilityService.isScreenReaderEnabled) {
          HapticFeedback.lightImpact();
        }
        onTap!();
      } : null,
      onLongPress: onLongPress != null ? () {
        if (accessibilityService.isScreenReaderEnabled) {
          HapticFeedback.heavyImpact();
        }
        onLongPress!();
      } : null,
      child: child);
  }
}

/// Accessibility-enhanced button widget
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final String? semanticsHint;
  final bool isEnabled;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final double? elevation;

  const AccessibleButton({
    Key? key,
    required this.child,
    this.onPressed,
    required this.semanticsLabel,
    this.semanticsHint,
    this.isEnabled = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      isButton: true,
      isEnabled: isEnabled,
      onTap: onPressed,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? 
            accessibilityService.getAccessibleColor(AppTheme.accent),
          foregroundColor: foregroundColor ?? 
            accessibilityService.getAccessibleColor(AppTheme.primaryAction),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8.0)),
          elevation: elevation ?? (accessibilityService.isHighContrastEnabled ? 8 : 4),
          textStyle: TextStyle(
            fontSize: accessibilityService.getAccessibleTextSize(16),
            fontWeight: FontWeight.w600)),
        child: child));
  }
}

/// Accessibility-enhanced text field widget
class AccessibleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AccessibleTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.isRequired = false,
    this.keyboardType,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: '$labelText${isRequired ? ' (required)' : ''}',
      semanticsHint: hintText,
      isTextField: true,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(
          fontSize: accessibilityService.getAccessibleTextSize(16),
          color: accessibilityService.getAccessibleColor(AppTheme.primaryText)),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
            fontSize: accessibilityService.getAccessibleTextSize(14),
            color: accessibilityService.getAccessibleColor(AppTheme.secondaryText)),
          hintStyle: TextStyle(
            fontSize: accessibilityService.getAccessibleTextSize(14),
            color: accessibilityService.getAccessibleColor(AppTheme.secondaryText)),
          errorStyle: TextStyle(
            fontSize: accessibilityService.getAccessibleTextSize(12),
            color: accessibilityService.getAccessibleColor(AppTheme.error)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              
              width: accessibilityService.isHighContrastEnabled ? 2 : 1)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: accessibilityService.getAccessibleColor(AppTheme.accent),
              width: accessibilityService.isHighContrastEnabled ? 3 : 2)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: accessibilityService.getAccessibleColor(AppTheme.error),
              width: accessibilityService.isHighContrastEnabled ? 3 : 2)))));
  }
}

/// Accessibility-enhanced card widget
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const AccessibleCard({
    Key? key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      isButton: onTap != null,
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? 
          accessibilityService.getAccessibleColor(AppTheme.primaryBackground, isBackground: true),
        elevation: elevation ?? (accessibilityService.isHighContrastEnabled ? 8 : 4),
        margin: margin ?? EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8)),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: Padding(
            padding: padding ?? EdgeInsets.all(16),
            child: child))));
  }
}

/// Accessibility-enhanced image widget
class AccessibleImage extends StatelessWidget {
  final String imageUrl;
  final String semanticsLabel;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const AccessibleImage({
    Key? key,
    required this.imageUrl,
    required this.semanticsLabel,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAccessibilityWidget(
      semanticsLabel: semanticsLabel,
      isImage: true,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CustomImageWidget(
          imageUrl: imageUrl,
          width: width ?? 0,
          height: height ?? 0,
          fit: fit ?? BoxFit.cover)));
  }
}

/// Accessibility-enhanced list item widget
class AccessibleListItem extends StatelessWidget {
  final Widget child;
  final String semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsets? padding;

  const AccessibleListItem({
    Key? key,
    required this.child,
    required this.semanticsLabel,
    this.semanticsHint,
    this.onTap,
    this.isSelected = false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      isButton: onTap != null,
      isSelected: isSelected,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: child
      )
    );
  }
}

/// Accessibility-enhanced header widget
class AccessibleHeader extends StatelessWidget {
  final String text;
  final int level; // 1-6 for heading levels
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsets? padding;

  const AccessibleHeader({
    Key? key,
    required this.text,
    this.level = 1,
    this.style,
    this.textAlign,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: text,
      semanticsHint: 'Heading level $level',
      isHeader: true,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          text,
          textAlign: textAlign,
          style: style ?? TextStyle(
            fontSize: accessibilityService.getAccessibleTextSize(24 - (level * 2)),
            fontWeight: FontWeight.bold,
            color: accessibilityService.getAccessibleColor(AppTheme.primaryText)))));
  }
}

/// Accessibility-enhanced progress indicator
class AccessibleProgressIndicator extends StatelessWidget {
  final double progress;
  final String semanticsLabel;
  final String? semanticsHint;
  final Color? backgroundColor;
  final Color? valueColor;
  final double? minHeight;

  const AccessibleProgressIndicator({
    Key? key,
    required this.progress,
    required this.semanticsLabel,
    this.semanticsHint,
    this.backgroundColor,
    this.valueColor,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService.instance;

    return CustomAccessibilityWidget(
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      semanticsValue: '${(progress * 100).round()}%',
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: backgroundColor ?? 
          accessibilityService.getAccessibleColor(AppTheme.accent),
        valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? accessibilityService.getAccessibleColor(AppTheme.accent)),
        minHeight: minHeight ?? (accessibilityService.isScreenReaderEnabled ? 8 : 4)));
  }
}