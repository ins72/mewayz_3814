import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../services/workspace_service.dart';

class GoalBasedRoleSuggestionsWidget extends StatelessWidget {
  final WorkspaceGoal goal;
  final Function(MemberRole) onRoleSelected;

  const GoalBasedRoleSuggestionsWidget({
    Key? key,
    required this.goal,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workspaceService = WorkspaceService();
    final roleSuggestions = workspaceService.getGoalBasedRoleSuggestions(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Team Roles',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Based on your workspace goal, here are recommended team roles:',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 2.h),
        
        ...roleSuggestions.map((suggestion) => _buildRoleSuggestionCard(suggestion)),
      ],
    );
  }

  Widget _buildRoleSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getRoleIcon(suggestion['role']),
                  color: const Color(0xFFF1F1F1),
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['title'],
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF1F1F1),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      suggestion['description'],
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFFF1F1F1).withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => onRoleSelected(suggestion['role']),
                child: Text(
                  'Select',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFFFDFDFD),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          // Permissions
          Text(
            'Permissions:',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1),
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: (suggestion['permissions'] as List<String>).map((permission) => 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  permission.replaceAll('_', ' ').toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: const Color(0xFFF1F1F1).withAlpha(204),
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return Icons.star;
      case MemberRole.admin:
        return Icons.admin_panel_settings;
      case MemberRole.manager:
        return Icons.supervisor_account;
      case MemberRole.member:
        return Icons.person;
      case MemberRole.viewer:
        return Icons.visibility;
    }
  }
}