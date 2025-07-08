import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class SecurityHeaderWidget extends StatelessWidget {
  const SecurityHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mewayz Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Center(
            child: Text(
              'M',
              style: AppTheme.darkTheme.textTheme.headlineLarge?.copyWith(
                color: AppTheme.primaryAction,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // App Name
        Text(
          'Mewayz',
          style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 4.h),

        // Security Shield Icon
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: AppTheme.success.withAlpha(26),
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(
              color: AppTheme.success.withAlpha(77),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.shield_outlined,
              color: AppTheme.success,
              size: 8.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Title
        Text(
          'Reset Your Password',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 2.h),

        // Subtitle
        Text(
          'Create a new secure password for your account',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
