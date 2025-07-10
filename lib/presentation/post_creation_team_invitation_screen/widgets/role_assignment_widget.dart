import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../core/app_constants.dart';

class RoleAssignmentWidget extends StatelessWidget {
  final MemberRole selectedRole;
  final Function(MemberRole) onRoleChanged;

  const RoleAssignmentWidget({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role Assignment',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600)),
          SizedBox(height: 3.w),
          ...MemberRole.values.map((role) => _buildRoleOption(role)),
        ],
      ),
    );
  }

  Widget _buildRoleOption(MemberRole role) {
    return RadioListTile<MemberRole>(
      title: Text(
        role.displayName.toUpperCase(),
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primaryText)),
      subtitle: Text(
        _getRoleDescription(role),
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.secondaryText)),
      value: role,
      groupValue: selectedRole,
      onChanged: (MemberRole? value) {
        if (value != null) {
          onRoleChanged(value);
        }
      },
      activeColor: AppTheme.accent);
  }

  String _getRoleDescription(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Full access to all workspace features and settings';
      case MemberRole.admin:
        return 'Manage workspace settings and team members';
      case MemberRole.manager:
        return 'Manage team content and moderate permissions';
      case MemberRole.member:
        return 'Create and manage content, limited settings access';
      case MemberRole.viewer:
        return 'View-only access to workspace content';
    }
  }
}

// Remove duplicate enum definition - using the one from app_constants.dart