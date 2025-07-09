import '../../../core/app_export.dart';
import './verification_code_input_widget.dart';

class AuthenticatorVerificationWidget extends StatelessWidget {
  final String verificationCode;
  final bool isLoading;
  final String? errorMessage;
  final int attemptCount;
  final int maxAttempts;
  final Function(String) onCodeChanged;

  const AuthenticatorVerificationWidget({
    Key? key,
    required this.verificationCode,
    required this.isLoading,
    required this.errorMessage,
    required this.attemptCount,
    required this.maxAttempts,
    required this.onCodeChanged,
  }) : super(key: key);

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Authenticator Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.warning.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.phone_android,
              size: 40,
              color: AppTheme.warning,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Authenticator App',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 8),

          // Instructions
          Text(
            'Enter the 6-digit code from your authenticator app',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // QR Code Setup (if first time)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // QR Code Placeholder
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 60,
                        color: AppTheme.secondaryText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QR Code',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Manual Entry Key
                Text(
                  'Manual Entry Key',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ABCD EFGH IJKL MNOP QRST UVWX YZ12 3456',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          _copyToClipboard('ABCDEFGHIJKLMNOPQRSTUVWXYZ123456');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Key copied to clipboard'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          size: 16,
                          color: AppTheme.accent,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Setup Instructions
                Text(
                  '1. Scan the QR code with your authenticator app\n2. Or manually enter the key above\n3. Enter the 6-digit code below',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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

          // Supported Apps
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
                      Icons.apps,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Supported Apps',
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
                  '• Google Authenticator\n• Microsoft Authenticator\n• Authy\n• 1Password\n• Bitwarden',
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