import '../../../core/app_export.dart';
import './verification_code_input_widget.dart';

class SmsVerificationWidget extends StatelessWidget {
  final String phoneNumber;
  final String verificationCode;
  final bool isLoading;
  final bool canResend;
  final int resendCountdown;
  final String? errorMessage;
  final int attemptCount;
  final int maxAttempts;
  final Function(String) onCodeChanged;
  final VoidCallback onResendCode;

  const SmsVerificationWidget({
    Key? key,
    required this.phoneNumber,
    required this.verificationCode,
    required this.isLoading,
    required this.canResend,
    required this.resendCountdown,
    required this.errorMessage,
    required this.attemptCount,
    required this.maxAttempts,
    required this.onCodeChanged,
    required this.onResendCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // SMS Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.sms_outlined,
              size: 40,
              color: AppTheme.success,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'SMS Verification',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 8),

          // Phone Number
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.secondaryText,
              ),
              children: [
                const TextSpan(text: 'Enter the 6-digit code sent to '),
                TextSpan(
                  text: phoneNumber,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Verification Code Input
          VerificationCodeInputWidget(
            code: verificationCode,
            onCodeChanged: onCodeChanged,
            isLoading: isLoading,
            hasError: errorMessage != null,
          ),

          const SizedBox(height: 24),

          // Error Message
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppTheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          errorMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.error,
                          ),
                        ),
                        if (attemptCount > 0)
                          Text(
                            'Attempts: $attemptCount/$maxAttempts',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.error.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Resend Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canResend ? onResendCode : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canResend ? AppTheme.primaryAction : AppTheme.surface,
                foregroundColor: canResend
                    ? AppTheme.primaryBackground
                    : AppTheme.secondaryText,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                canResend ? 'Resend Code' : 'Resend Code (${resendCountdown}s)',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Additional Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SMS Information',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• SMS may take up to 2 minutes to arrive\n• Check your phone for the verification code\n• Standard messaging rates may apply',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}