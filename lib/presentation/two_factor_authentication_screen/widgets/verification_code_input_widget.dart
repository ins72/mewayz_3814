import '../../../core/app_export.dart';

class VerificationCodeInputWidget extends StatefulWidget {
  final String code;
  final Function(String) onCodeChanged;
  final bool isLoading;
  final bool hasError;

  const VerificationCodeInputWidget({
    Key? key,
    required this.code,
    required this.onCodeChanged,
    required this.isLoading,
    required this.hasError,
  }) : super(key: key);

  @override
  State<VerificationCodeInputWidget> createState() =>
      _VerificationCodeInputWidgetState();
}

class _VerificationCodeInputWidgetState
    extends State<VerificationCodeInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());

    // Set initial values if code is provided
    if (widget.code.isNotEmpty) {
      for (int i = 0; i < widget.code.length && i < 6; i++) {
        _controllers[i].text = widget.code[i];
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty) {
      // Move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Build complete code
    String completeCode = '';
    for (final controller in _controllers) {
      completeCode += controller.text;
    }

    widget.onCodeChanged(completeCode);
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Code Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Container(
              width: 45,
              height: 55,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.hasError
                      ? AppTheme.error
                      : (_focusNodes[index].hasFocus
                          ? AppTheme.accent
                          : AppTheme.border),
                  width: widget.hasError ? 2 : 1,
                ),
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) => _onKeyEvent(event, index),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  enabled: !widget.isLoading,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => _onCodeChanged(value, index),
                  onTap: () {
                    if (_controllers[index].text.isNotEmpty) {
                      _controllers[index].selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: _controllers[index].text.length),
                      );
                    }
                  },
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Loading Indicator
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            ),
          ),

        // Instructions
        if (!widget.isLoading)
          Text(
            'Enter the 6-digit verification code',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}