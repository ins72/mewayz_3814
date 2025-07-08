import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class EmailVerificationStatusWidget extends StatelessWidget {
  final String userEmail;
  final VoidCallback onOpenEmailApp;

  const EmailVerificationStatusWidget({
    Key? key,
    required this.userEmail,
    required this.onOpenEmailApp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Text(
          'Check Your Email',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Email Status
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
              // Email Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 30,
                  color: AppTheme.success,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Email Sent Status
              Text(
                'Email Sent Successfully',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // User Email
              Text(
                userEmail,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Instructions
              Text(
                'Please check your inbox and spam folder for the verification email. Click the link in the email to verify your account.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.secondaryText,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Open Email App Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onOpenEmailApp,
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.accent.withValues(alpha: 0.1),
                    foregroundColor: AppTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email,
                        size: 16,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Open Email App',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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