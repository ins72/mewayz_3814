
import '../core/app_export.dart';

class CustomFormFieldWidget extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final BorderRadius? borderRadius;

  const CustomFormFieldWidget({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.semanticsLabel,
    this.semanticsHint,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.fillColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<CustomFormFieldWidget> createState() => _CustomFormFieldWidgetState();
}

class _CustomFormFieldWidgetState extends State<CustomFormFieldWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppTheme.error,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
        ],
        
        Semantics(
          label: widget.semanticsLabel ?? widget.label,
          hint: widget.semanticsHint ?? widget.hint,
          textField: true,
          enabled: widget.enabled,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTap: widget.onTap,
            validator: widget.validator,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled ? AppTheme.primaryText : AppTheme.secondaryText,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              fillColor: widget.fillColor ?? (widget.enabled ? AppTheme.surfaceVariant : AppTheme.surface),
              filled: true,
              contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingM,
              ),
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.accent,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.border.withAlpha(128),
                  width: 1.5,
                ),
              ),
              hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText.withAlpha(179),
              ),
              labelStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: _isFocused ? AppTheme.accent : AppTheme.secondaryText,
              ),
              errorStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.error,
              ),
              helperStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSearchFieldWidget extends StatefulWidget {
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;
  final String? semanticsLabel;
  final String? semanticsHint;

  const CustomSearchFieldWidget({
    Key? key,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : super(key: key);

  @override
  State<CustomSearchFieldWidget> createState() => _CustomSearchFieldWidgetState();
}

class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormFieldWidget(
      controller: _controller,
      hint: widget.hint ?? 'Search...',
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      semanticsLabel: widget.semanticsLabel ?? 'Search field',
      semanticsHint: widget.semanticsHint ?? 'Enter search terms',
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      prefixIcon: Icon(
        Icons.search,
        color: AppTheme.secondaryText,
        size: AppTheme.iconSizeM,
      ),
      suffixIcon: _hasText
          ? IconButton(
              onPressed: _onClear,
              icon: Icon(
                Icons.clear,
                color: AppTheme.secondaryText,
                size: AppTheme.iconSizeM,
              ),
              tooltip: 'Clear search',
            )
          : null,
    );
  }
}

class CustomDropdownFieldWidget<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool required;
  final Widget? prefixIcon;
  final String? semanticsLabel;
  final String? semanticsHint;

  const CustomDropdownFieldWidget({
    Key? key,
    this.label,
    this.hint,
    this.value,
    this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.required = false,
    this.prefixIcon,
    this.semanticsLabel,
    this.semanticsHint,
  }) : super(key: key);

  @override
  State<CustomDropdownFieldWidget<T>> createState() => _CustomDropdownFieldWidgetState<T>();
}

class _CustomDropdownFieldWidgetState<T> extends State<CustomDropdownFieldWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppTheme.error,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
        ],
        
        Semantics(
          label: widget.semanticsLabel ?? widget.label,
          hint: widget.semanticsHint ?? widget.hint,
          button: true,
          enabled: widget.enabled,
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.enabled ? widget.onChanged : null,
            validator: widget.validator,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled ? AppTheme.primaryText : AppTheme.secondaryText,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              fillColor: widget.enabled ? AppTheme.surfaceVariant : AppTheme.surface,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingM,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.accent,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 1.5,
                ),
              ),
            ),
            dropdownColor: AppTheme.surface,
            icon: Icon(
              Icons.arrow_drop_down,
              color: AppTheme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}