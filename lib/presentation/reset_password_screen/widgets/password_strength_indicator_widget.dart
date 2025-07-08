import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final double strength;
  final String strengthText;
  final Color strengthColor;
  final Map<String, bool> requirements;

  const PasswordStrengthIndicatorWidget({
    Key? key,
    required this.strength,
    required this.strengthText,
    required this.strengthColor,
    required this.requirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength Meter
        if (strengthText.isNotEmpty) ...[
          Row(
            children: [
              Text(
                'Password Strength: ',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
              Text(
                strengthText,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: strengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.w),

          // Progress Bar
          Container(
            height: 1.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.5.w),
              color: AppTheme.border,
            ),
            child: Row(
              children: [
                // Progress Fill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 1.w,
                  width: (100.w - 12.w) * strength,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.5.w),
                    color: strengthColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.w),
        ],

        // Requirements List
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Requirements:',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 2.w),

              // Requirements
              _buildRequirement(
                'At least 8 characters',
                requirements['minLength'] ?? false,
              ),
              _buildRequirement(
                'One uppercase letter',
                requirements['uppercase'] ?? false,
              ),
              _buildRequirement(
                'One lowercase letter',
                requirements['lowercase'] ?? false,
              ),
              _buildRequirement(
                'One number',
                requirements['number'] ?? false,
              ),
              _buildRequirement(
                'One special character (!@#\$%^&*)',
                requirements['specialChar'] ?? false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? AppTheme.success : AppTheme.secondaryText,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: isValid ? AppTheme.success : AppTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
