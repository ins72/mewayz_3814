import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class TwoFactorModalWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const TwoFactorModalWidget({
    Key? key,
    required this.onSuccess,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<TwoFactorModalWidget> createState() => _TwoFactorModalWidgetState();
}

class _TwoFactorModalWidgetState extends State<TwoFactorModalWidget> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Auto focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    }
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _currentCode {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _currentCode;
    if (code.length != 6) return;

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock verification - accept "123456" as valid code
      if (code == '123456') {
        widget.onSuccess();
      } else {
        setState(() {
          _error = 'Invalid verification code. Please try again.';
          // Clear all fields
          for (var controller in _controllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Verification failed. Please try again.';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendCode() async {
    // Simulate resend delay
    await Future.delayed(const Duration(seconds: 1));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification code sent successfully',
            style: AppTheme.darkTheme.textTheme.bodyMedium),
        backgroundColor: AppTheme.success));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.primaryBackground.withValues(alpha: 0.8),
        child: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(4.w)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // Header
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Two-Factor Authentication',
                            style: AppTheme.darkTheme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        GestureDetector(
                            onTap: widget.onCancel,
                            child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.secondaryText,
                                size: 6.w)),
                      ]),

                  SizedBox(height: 3.h),

                  // Description
                  Text(
                      'Enter the 6-digit verification code sent to your registered device.',
                      style: AppTheme.darkTheme.textTheme.bodyMedium
                          ?.copyWith(color: AppTheme.secondaryText),
                      textAlign: TextAlign.center),

                  SizedBox(height: 4.h),

                  // Code Input Fields
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryBackground,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                    color: _error != null
                                        ? AppTheme.error
                                        : AppTheme.border,
                                    width: 1)),
                            child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                enabled: !_isVerifying,
                                style: AppTheme.darkTheme.textTheme.titleLarge
                                    ?.copyWith(
                                        color: AppTheme.primaryText,
                                        fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                    border: InputBorder.none, counterText: ''),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) =>
                                    _onCodeChanged(value, index),
                                onTap: () {
                                  _controllers[index].selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                              _controllers[index].text.length));
                                }));
                      })),

                  SizedBox(height: 2.h),

                  // Error Message
                  _error != null
                      ? Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.w),
                              border: Border.all(
                                  color: AppTheme.error.withValues(alpha: 0.3),
                                  width: 1)),
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'error_outline',
                                color: AppTheme.error,
                                size: 5.w),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: Text(_error!,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(color: AppTheme.error))),
                          ]))
                      : const SizedBox.shrink(),

                  SizedBox(height: 4.h),

                  // Verify Button
                  SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                          onPressed: _isVerifying || _currentCode.length != 6
                              ? null
                              : _verifyCode,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _currentCode.length == 6 && !_isVerifying
                                      ? AppTheme.primaryAction
                                      : AppTheme.secondaryText,
                              foregroundColor: AppTheme.primaryBackground,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.w))),
                          child: _isVerifying
                              ? SizedBox(
                                  width: 5.w,
                                  height: 5.w,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppTheme.primaryBackground)))
                              : Text('Verify',
                                  style: AppTheme
                                      .darkTheme.textTheme.titleMedium
                                      ?.copyWith(
                                          color: AppTheme.primaryBackground,
                                          fontWeight: FontWeight.w600)))),

                  SizedBox(height: 3.h),

                  // Resend Code
                  GestureDetector(
                      onTap: _resendCode,
                      child: Text('Didn\'t receive the code? Resend',
                          style: AppTheme.darkTheme.textTheme.bodyMedium
                              ?.copyWith(
                                  color: AppTheme.accent,
                                  decoration: TextDecoration.underline))),

                  SizedBox(height: 2.h),

                  // Helper Text
                  Text('Use code: 123456 for demo',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic)),
                ]))));
  }
}