import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

enum MemberRole { owner, admin, manager, member, viewer }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Assignment',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 1.h),
        Text(
          'Select the role for invited team members',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179))),
        SizedBox(height: 2.h),
        
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1)),
          child: Column(
            children: [
              _buildRoleOption(
                MemberRole.admin,
                'Admin',
                'Full access to manage workspace and team members',
                Icons.admin_panel_settings),
              SizedBox(height: 2.h),
              _buildRoleOption(
                MemberRole.manager,
                'Manager',
                'Can manage content and invite team members',
                Icons.supervisor_account),
              SizedBox(height: 2.h),
              _buildRoleOption(
                MemberRole.member,
                'Member',
                'Can view and edit workspace content',
                Icons.person),
              SizedBox(height: 2.h),
              _buildRoleOption(
                MemberRole.viewer,
                'Viewer',
                'Can only view workspace content',
                Icons.visibility),
            ])),
        SizedBox(height: 2.h),
        
        // Role preview
        _buildRolePreview(),
      ]);
  }

  Widget _buildRoleOption(MemberRole role, String title, String description, IconData icon) {
    final isSelected = selectedRole == role;
    
    return GestureDetector(
      onTap: () => onRoleChanged(role),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF282828) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: const Color(0xFFFDFDFD), width: 1)
              : null),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFDFDFD) : const Color(0xFFF1F1F1).withAlpha(179),
              size: 5.w),
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
                      color: const Color(0xFFF1F1F1))),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFF1F1F1).withAlpha(179))),
                ])),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFFFDFDFD),
                size: 5.w),
          ])));
  }

  Widget _buildRolePreview() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invitation Preview',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1))),
          SizedBox(height: 1.h),
          Text(
            'Invitees will receive an email with:',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFF1F1F1).withAlpha(179))),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.star,
                color: const Color(0xFFFDFDFD),
                size: 4.w),
              SizedBox(width: 2.w),
              Text(
                'Role: ${selectedRole.toString().split('.').last}',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFFF1F1F1))),
            ]),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Icon(
                Icons.security,
                color: const Color(0xFFFDFDFD),
                size: 4.w),
              SizedBox(width: 2.w),
              Text(
                'Permissions: ${_getRolePermissions(selectedRole)}',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFFF1F1F1))),
            ]),
        ]));
  }

  String _getRolePermissions(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Full control';
      case MemberRole.admin:
        return 'Manage all';
      case MemberRole.manager:
        return 'Edit & invite';
      case MemberRole.member:
        return 'View & edit';
      case MemberRole.viewer:
        return 'View only';
      default:
        return 'No permissions';
    }
  }
}