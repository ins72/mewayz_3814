import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../services/workspace_service.dart';

class GoalSelectionCardWidget extends StatelessWidget {
  final WorkspaceGoal goal;
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
  final String recommendedTeamSize;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalSelectionCardWidget({
    Key? key,
    required this.goal,
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
    required this.recommendedTeamSize,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF191919),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDFDFD) : const Color(0xFF282828),
            width: isSelected ? 2 : 1,
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
                    color: isSelected ? const Color(0xFFFDFDFD) : const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? const Color(0xFF141414) : const Color(0xFFF1F1F1),
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
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
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFFFDFDFD),
                    size: 6.w,
                  ),
              ],
            ),
            SizedBox(height: 3.h),
            
            // Features
            Text(
              'Key Features:',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF1F1F1),
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: features.map((feature) => Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  feature,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: const Color(0xFFF1F1F1).withAlpha(204),
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 2.h),
            
            // Team Size
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: const Color(0xFFF1F1F1).withAlpha(179),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Recommended: $recommendedTeamSize',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFFF1F1F1).withAlpha(179),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}