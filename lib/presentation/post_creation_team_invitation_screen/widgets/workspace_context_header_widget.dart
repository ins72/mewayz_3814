import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_constants.dart';

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
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: const BoxDecoration(
        color: Color(0xFF191919),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF282828),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: const Color(0xFF282828),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: const Color(0xFFF1F1F1),
                size: 4.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          
          // Workspace info
          Row(
            children: [
              // Workspace avatar
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF404040),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getGoalIcon(goal),
                  color: const Color(0xFFFDFDFD),
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              
              // Workspace details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspace['name'] ?? 'New Workspace',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF1F1F1),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      goal.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFFF1F1F1).withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          // Progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group_add,
                  color: const Color(0xFFFDFDFD),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Step 3 of 3 • Team Invitation',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: const Color(0xFFF1F1F1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGoalIcon(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return Icons.share;
      case WorkspaceGoal.ecommerceBusiness:
        return Icons.store;
      case WorkspaceGoal.courseCreation:
        return Icons.school;
      case WorkspaceGoal.leadGeneration:
        return Icons.trending_up;
      case WorkspaceGoal.allInOneBusiness:
        return Icons.business_center;
      default:
        return Icons.business;
    }
  }
}