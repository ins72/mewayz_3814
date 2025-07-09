import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../services/workspace_service.dart';
import '../../../widgets/custom_image_widget.dart';

class WorkspaceContextHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> workspace;
  final WorkspaceGoal goal;

  const WorkspaceContextHeaderWidget({
    Key? key,
    required this.workspace,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF282828),
            width: 1))),
      child: Row(
        children: [
          // Workspace Logo
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1)),
            child: workspace['logo_url'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: workspace['logo_url'],
                      fit: BoxFit.cover))
                : Icon(
                    _getGoalIcon(goal),
                    color: const Color(0xFFF1F1F1),
                    size: 6.w)),
          SizedBox(width: 3.w),
          
          // Workspace Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspace['name'] ?? 'Workspace',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF1F1F1))),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        _getGoalDisplayName(goal),
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: const Color(0xFFF1F1F1).withAlpha(204)))),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 3.w),
                    SizedBox(width: 1.w),
                    Text(
                      'Created',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.green)),
                  ]),
              ])),
        ]));
  }

  IconData _getGoalIcon(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return Icons.campaign;
      case WorkspaceGoal.ecommerceBusiness:
        return Icons.store;
      case WorkspaceGoal.courseCreation:
        return Icons.school;
      case WorkspaceGoal.leadGeneration:
        return Icons.trending_up;
      case WorkspaceGoal.allInOneBusiness:
        return Icons.business_center;
    }
  }

  String _getGoalDisplayName(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return 'Social Media';
      case WorkspaceGoal.ecommerceBusiness:
        return 'E-commerce';
      case WorkspaceGoal.courseCreation:
        return 'Course Creation';
      case WorkspaceGoal.leadGeneration:
        return 'Lead Generation';
      case WorkspaceGoal.allInOneBusiness:
        return 'All-in-One Business';
    }
  }
}