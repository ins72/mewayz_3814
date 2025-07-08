import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final String selectedVisibility;
  final bool allowEmailContact;
  final bool allowPhoneContact;
  final ValueChanged<String> onVisibilityChanged;
  final ValueChanged<bool> onEmailContactChanged;
  final ValueChanged<bool> onPhoneContactChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.selectedVisibility,
    required this.allowEmailContact,
    required this.allowPhoneContact,
    required this.onVisibilityChanged,
    required this.onEmailContactChanged,
    required this.onPhoneContactChanged,
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
            'Privacy Settings',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 24),

          // Profile Visibility
          Text(
            'Profile Visibility',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          _buildVisibilityOption(
            'public',
            'Public',
            'Anyone can view your profile',
            Icons.public,
          ),

          const SizedBox(height: 12),

          _buildVisibilityOption(
            'workspace',
            'Workspace Only',
            'Only workspace members can view your profile',
            Icons.group,
          ),

          const SizedBox(height: 12),

          _buildVisibilityOption(
            'private',
            'Private',
            'Only you can view your profile',
            Icons.lock,
          ),

          const SizedBox(height: 32),

          // Contact Preferences
          Text(
            'Contact Preferences',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          _buildToggleOption(
            'Allow Email Contact',
            'Team members can contact you via email',
            allowEmailContact,
            onEmailContactChanged,
          ),

          const SizedBox(height: 16),

          _buildToggleOption(
            'Allow Phone Contact',
            'Team members can contact you via phone',
            allowPhoneContact,
            onPhoneContactChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = selectedVisibility == value;

    return GestureDetector(
      onTap: () => onVisibilityChanged(value),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withAlpha(26)
              : AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? AppTheme.accent : AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
          inactiveTrackColor: AppTheme.border,
        ),
      ],
    );
  }
}
