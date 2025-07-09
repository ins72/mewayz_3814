import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final String privacyLevel;
  final Function(String) onPrivacyChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.privacyLevel,
    required this.onPrivacyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Level',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Control who can access your workspace',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 2.h),
        
        _buildPrivacyOption(
          'public',
          'Public',
          'Anyone can view workspace content',
          Icons.public,
        ),
        SizedBox(height: 2.h),
        
        _buildPrivacyOption(
          'private',
          'Private',
          'Only workspace members can access',
          Icons.lock,
        ),
        SizedBox(height: 2.h),
        
        _buildPrivacyOption(
          'team_only',
          'Team Only',
          'Only invited team members can access',
          Icons.group,
        ),
      ],
    );
  }

  Widget _buildPrivacyOption(String value, String title, String description, IconData icon) {
    final isSelected = privacyLevel == value;
    
    return GestureDetector(
      onTap: () => onPrivacyChanged(value),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: const Color(0xFF191919),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDFDFD) : const Color(0xFF282828),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
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
                size: 5.w,
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
                      fontSize: 14.sp,
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
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }
}