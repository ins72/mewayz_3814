import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class WorkspaceSettingsWidget extends StatelessWidget {
  final Map<String, bool> defaultPermissions;
  final Function(Map<String, bool>) onPermissionsChanged;
  final Function(Map<String, dynamic>) onBillingPreferencesChanged;

  const WorkspaceSettingsWidget({
    Key? key,
    required this.defaultPermissions,
    required this.onPermissionsChanged,
    required this.onBillingPreferencesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Default Member Permissions
        Text(
          'Default Member Permissions',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Set default permissions for new team members',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 2.h),
        
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildPermissionToggle(
                'can_view',
                'Can View',
                'Members can view workspace content',
                Icons.visibility,
                defaultPermissions['can_view'] ?? true,
              ),
              SizedBox(height: 2.h),
              _buildPermissionToggle(
                'can_edit',
                'Can Edit',
                'Members can edit workspace content',
                Icons.edit,
                defaultPermissions['can_edit'] ?? false,
              ),
              SizedBox(height: 2.h),
              _buildPermissionToggle(
                'can_invite',
                'Can Invite',
                'Members can invite new team members',
                Icons.person_add,
                defaultPermissions['can_invite'] ?? false,
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        
        // Billing Preferences
        Text(
          'Billing Preferences',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Configure billing and subscription preferences',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 2.h),
        
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: const Color(0xFFF1F1F1).withAlpha(179),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Start with Free Plan',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF1F1F1),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'You can upgrade to premium features later from workspace settings.',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFFF1F1F1).withAlpha(179),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionToggle(
    String key,
    String title,
    String description,
    IconData icon,
    bool value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFF1F1F1).withAlpha(179),
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF1F1F1),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFFF1F1F1).withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            final updatedPermissions = Map<String, bool>.from(defaultPermissions);
            updatedPermissions[key] = newValue;
            onPermissionsChanged(updatedPermissions);
          },
          activeColor: const Color(0xFFFDFDFD),
          activeTrackColor: const Color(0xFFFDFDFD).withAlpha(77),
          inactiveThumbColor: const Color(0xFF282828),
          inactiveTrackColor: const Color(0xFF282828).withAlpha(77),
        ),
      ],
    );
  }
}