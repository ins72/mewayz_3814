import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SocialRegistrationWidget extends StatelessWidget {
  final VoidCallback onGoogleSignUp;
  final VoidCallback onAppleSignUp;

  const SocialRegistrationWidget({
    Key? key,
    required this.onGoogleSignUp,
    required this.onAppleSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppTheme.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or sign up with',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppTheme.border)),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGoogleSignUp,
                icon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      'G',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                label: Text(
                  'Google',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.surface,
                  side: const BorderSide(color: AppTheme.border),
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAppleSignUp,
                icon: const Icon(
                  Icons.apple,
                  color: AppTheme.primaryText,
                  size: 20,
                ),
                label: Text(
                  'Apple',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.surface,
                  side: const BorderSide(color: AppTheme.border),
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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