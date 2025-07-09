import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/app_export.dart';

class EmailVerificationFormWidget extends StatelessWidget {
  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final bool isVerifying;
  final bool isResendingCode;
  final String? errorMessage;
  final int resendCooldown;
  final VoidCallback onVerify;
  final VoidCallback onResendCode;

  const EmailVerificationFormWidget({
    Key? key,
    required this.codeController,
    required this.codeFocusNode,
    required this.isVerifying,
    required this.isResendingCode,
    this.errorMessage,
    required this.resendCooldown,
    required this.onVerify,
    required this.onResendCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // PIN Code Input
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: codeController,
          focusNode: codeFocusNode,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(2.w),
            fieldHeight: 12.w,
            fieldWidth: 12.w,
            activeFillColor: AppTheme.surface,
            inactiveFillColor: AppTheme.surface,
            selectedFillColor: AppTheme.surface,
            activeColor: AppTheme.accent,
            inactiveColor: AppTheme.border,
            selectedColor: AppTheme.accent,
            errorBorderColor: AppTheme.error,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          enabled: !isVerifying,
          textStyle: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
          onCompleted: (value) {
            if (value.length == 6) {
              onVerify();
            }
          },
          onChanged: (value) {
            // Clear error when user starts typing
          },
        ),

        SizedBox(height: 3.h),

        // Error Message
        if (errorMessage != null)
          Container(
            padding: EdgeInsets.all(3.w),
            margin: EdgeInsets.only(bottom: 3.h),
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
                    errorMessage!,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: isVerifying || codeController.text.length != 6 
                ? null 
                : onVerify,
            style: ElevatedButton.styleFrom(
              backgroundColor: codeController.text.length == 6 && !isVerifying
                  ? AppTheme.primaryAction
                  : AppTheme.secondaryText,
              foregroundColor: AppTheme.primaryBackground,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            child: isVerifying
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
                    'Verify Email',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        SizedBox(height: 4.h),

        // Resend Code Section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did not receive the code? ',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            if (resendCooldown > 0)
              Text(
                'Resend in ${resendCooldown}s',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              )
            else
              GestureDetector(
                onTap: isResendingCode ? null : onResendCode,
                child: Text(
                  isResendingCode ? 'Sending...' : 'Resend Code',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: isResendingCode 
                        ? AppTheme.secondaryText 
                        : AppTheme.accent,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 3.h),

        // Help Text
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.accent.withAlpha(77),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.accent,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Check your email including spam folder for the verification code.',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}