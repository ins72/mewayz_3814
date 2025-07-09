import '../../../core/app_export.dart';

class EmailVerificationFormWidget extends StatefulWidget {
  final String userEmail;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;
  final bool isLoading;
  final bool canResend;
  final int countdown;

  const EmailVerificationFormWidget({
    Key? key,
    required this.userEmail,
    required this.onResend,
    required this.onChangeEmail,
    required this.isLoading,
    required this.canResend,
    required this.countdown,
  }) : super(key: key);

  @override
  State<EmailVerificationFormWidget> createState() =>
      _EmailVerificationFormWidgetState();
}

class _EmailVerificationFormWidgetState
    extends State<EmailVerificationFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Display
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
              Text(
                'Email Address',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.userEmail,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Instructions
        Text(
          'Check your email',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),

        const SizedBox(height: 8),

        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
              height: 1.4,
            ),
            children: [
              const TextSpan(
                text: 'We\'ve sent a verification link to ',
              ),
              TextSpan(
                text: widget.userEmail,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const TextSpan(
                text: '. Please check your inbox and spam folder.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: widget.canResend && !widget.isLoading
                    ? widget.onResend
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.canResend && !widget.isLoading
                      ? AppTheme.primaryAction
                      : AppTheme.surface,
                  foregroundColor: widget.canResend && !widget.isLoading
                      ? AppTheme.primaryBackground
                      : AppTheme.secondaryText,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.secondaryText,
                          ),
                        ),
                      )
                    : Text(
                        widget.canResend
                            ? 'Resend Email'
                            : 'Resend (${widget.countdown}s)',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onChangeEmail,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.surface,
                  foregroundColor: AppTheme.primaryText,
                  side: const BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Change Email',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}