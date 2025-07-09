import 'package:flutter/semantics.dart';

import '../core/app_export.dart';

class CustomAccessibilityWidget extends StatefulWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool? enabled;
  final bool? selected;
  final bool? button;
  final bool? header;
  final bool? textField;
  final bool? focusable;
  final bool? liveRegion;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFocus;
  final VoidCallback? onUnfocus;
  final double? sortKey;
  final bool excludeSemantics;

  const CustomAccessibilityWidget({
    Key? key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.enabled,
    this.selected,
    this.button,
    this.header,
    this.textField,
    this.focusable,
    this.liveRegion,
    this.onTap,
    this.onLongPress,
    this.onFocus,
    this.onUnfocus,
    this.sortKey,
    this.excludeSemantics = false,
  }) : super(key: key);

  @override
  State<CustomAccessibilityWidget> createState() => _CustomAccessibilityWidgetState();
}

class _CustomAccessibilityWidgetState extends State<CustomAccessibilityWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      widget.onFocus?.call();
    } else {
      widget.onUnfocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.excludeSemantics) {
      return widget.child;
    }

    return Semantics(
      label: widget.semanticsLabel,
      hint: widget.semanticsHint,
      enabled: widget.enabled,
      selected: widget.selected,
      button: widget.button,
      header: widget.header,
      textField: widget.textField,
      focusable: widget.focusable ?? widget.onTap != null,
      liveRegion: widget.liveRegion,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      sortKey: widget.sortKey != null ? OrdinalSortKey(widget.sortKey!) : null,
      child: Focus(
        focusNode: _focusNode,
        child: Container(
          decoration: _isFocused ? BoxDecoration(
            border: Border.all(
              color: AppTheme.accent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ) : null,
          child: widget.child,
        ),
      ),
    );
  }
}

class CustomScreenReaderWidget extends StatelessWidget {
  final String text;
  final Widget? child;
  final bool announceImmediately;
  final bool liveRegion;

  const CustomScreenReaderWidget({
    Key? key,
    required this.text,
    this.child,
    this.announceImmediately = false,
    this.liveRegion = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      liveRegion: liveRegion,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

class CustomFocusableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onFocus;
  final VoidCallback? onUnfocus;
  final bool autofocus;
  final String? semanticsLabel;
  final bool skipTraversal;

  const CustomFocusableWidget({
    Key? key,
    required this.child,
    this.onFocus,
    this.onUnfocus,
    this.autofocus = false,
    this.semanticsLabel,
    this.skipTraversal = false,
  }) : super(key: key);

  @override
  State<CustomFocusableWidget> createState() => _CustomFocusableWidgetState();
}

class _CustomFocusableWidgetState extends State<CustomFocusableWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      widget.onFocus?.call();
    } else {
      widget.onUnfocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      skipTraversal: widget.skipTraversal,
      child: Semantics(
        label: widget.semanticsLabel,
        focusable: true,
        child: Container(
          decoration: _isFocused ? BoxDecoration(
            border: Border.all(
              color: AppTheme.accent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ) : null,
          child: widget.child,
        ),
      ),
    );
  }
}

class CustomAnnouncementWidget extends StatefulWidget {
  final String message;
  final Widget? child;
  final Duration delay;

  const CustomAnnouncementWidget({
    Key? key,
    required this.message,
    this.child,
    this.delay = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<CustomAnnouncementWidget> createState() => _CustomAnnouncementWidgetState();
}

class _CustomAnnouncementWidgetState extends State<CustomAnnouncementWidget> {
  @override
  void initState() {
    super.initState();
    _announceMessage();
  }

  void _announceMessage() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        SemanticsService.announce(widget.message, TextDirection.ltr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.message,
      liveRegion: true,
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}

class CustomAccessibilityButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? semanticsLabel;
  final String? tooltip;
  final bool enabled;
  final bool selected;
  final EdgeInsets? padding;
  final double? minWidth;
  final double? minHeight;

  const CustomAccessibilityButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.semanticsLabel,
    this.tooltip,
    this.enabled = true,
    this.selected = false,
    this.padding,
    this.minWidth,
    this.minHeight,
  }) : super(key: key);

  @override
  State<CustomAccessibilityButton> createState() => _CustomAccessibilityButtonState();
}

class _CustomAccessibilityButtonState extends State<CustomAccessibilityButton> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: Focus(
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: widget.enabled ? widget.onPressed : null,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,
          child: Container(
            constraints: BoxConstraints(
              minWidth: widget.minWidth ?? AppTheme.minTouchTarget,
              minHeight: widget.minHeight ?? AppTheme.minTouchTarget,
            ),
            padding: widget.padding ?? EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: _isPressed 
                  ? AppTheme.accent.withAlpha(26) 
                  : Colors.transparent,
              border: _isFocused ? Border.all(
                color: AppTheme.accent,
                width: 2,
              ) : null,
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: widget.tooltip != null
                ? Tooltip(
                    message: widget.tooltip!,
                    child: widget.child,
                  )
                : widget.child,
          ),
        ),
      ),
    );
  }
}