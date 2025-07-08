import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final bool emailVerified;
  final VoidCallback? onEmailVerify;

  const ProfileFormWidget({
    Key? key,
    required this.fullNameController,
    required this.displayNameController,
    required this.emailController,
    required this.phoneController,
    required this.bioController,
    required this.emailVerified,
    this.onEmailVerify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 24),

          // Full Name
          _buildFormField(
            label: 'Full Name',
            controller: fullNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Display Name
          _buildFormField(
            label: 'Display Name',
            controller: displayNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Display name is required';
              }
              if (value.contains(' ')) {
                return 'Display name cannot contain spaces';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email
          _buildFormField(
            label: 'Email Address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            suffix: emailVerified
                ? Icon(
                    Icons.verified,
                    color: AppTheme.success,
                    size: 20,
                  )
                : TextButton(
                    onPressed: onEmailVerify,
                    child: Text(
                      'Verify',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Phone Number
          _buildFormField(
            label: 'Phone Number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Bio
          _buildFormField(
            label: 'Bio',
            controller: bioController,
            maxLines: 4,
            validator: (value) {
              if (value != null && value.length > 500) {
                return 'Bio cannot exceed 500 characters';
              }
              return null;
            },
          ),

          if (!emailVerified) ...[
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warning.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.warning),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: AppTheme.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please verify your email address to unlock all features',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryText,
          ),
          validator: validator,
          decoration: InputDecoration(
            fillColor: AppTheme.primaryBackground,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.accent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.error, width: 2),
            ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}