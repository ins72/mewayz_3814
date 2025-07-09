import 'package:pin_code_fields/pin_code_fields.dart';

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
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  
  bool _isVerifying = false;
  String? _errorMessage;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    // Auto-focus on the input field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _authService.verifyTwoFactorCode(_codeController.text);
      
      if (isValid) {
        HapticFeedback.lightImpact();
        widget.onSuccess();
      } else {
        setState(() {
          _errorMessage = 'Invalid code. Please try again.';
        });
        _codeController.clear();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
      });
      _codeController.clear();
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(128),
      child: Center(
        child: Container(
          width: 85.w,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Two-Factor Authentication',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.secondaryText,
                      size: 6.w,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Description
              Text(
                'Enter the 6-digit code from your authenticator app',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // PIN Code Input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _codeController,
                focusNode: _codeFocusNode,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(2.w),
                  fieldHeight: 12.w,
                  fieldWidth: 10.w,
                  activeFillColor: AppTheme.surface,
                  inactiveFillColor: AppTheme.surface,
                  selectedFillColor: AppTheme.surface,
                  activeColor: AppTheme.accent,
                  inactiveColor: AppTheme.border,
                  selectedColor: AppTheme.accent,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                textStyle: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
                onCompleted: (value) {
                  _verifyCode();
                },
                onChanged: (value) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),

              SizedBox(height: 2.h),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.error.withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        color: AppTheme.error,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: _isVerifying ? null : widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _isVerifying || _codeController.text.length != 6 
                            ? null 
                            : _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _codeController.text.length == 6 && !_isVerifying
                              ? AppTheme.primaryAction
                              : AppTheme.secondaryText,
                          foregroundColor: AppTheme.primaryBackground,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: _isVerifying
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryBackground,
                                  ),
                                ),
                              )
                            : Text(
                                'Verify',
                                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryBackground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Backup Code Option
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement backup code verification
                  },
                  child: Text(
                    'Use backup code instead',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}