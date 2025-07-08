import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class PasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPasswordVisible;
  final String? error;
  final String label;
  final String hintText;
  final VoidCallback onVisibilityToggle;

  const PasswordInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isPasswordVisible,
    required this.error,
    required this.label,
    required this.hintText,
    required this.onVisibilityToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 2.w),

        // Input Field
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: !isPasswordVisible,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            filled: true,
            fillColor: AppTheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: error != null ? AppTheme.error : AppTheme.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: error != null ? AppTheme.error : AppTheme.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: error != null ? AppTheme.error : AppTheme.accent,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 4.w,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.secondaryText,
                size: 6.w,
              ),
              onPressed: onVisibilityToggle,
            ),
          ),
        ),

        // Error Message
        if (error != null) ...[
          SizedBox(height: 2.w),
          Text(
            error!,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
