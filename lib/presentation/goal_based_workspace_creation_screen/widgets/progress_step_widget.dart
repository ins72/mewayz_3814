import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProgressStepWidget extends StatelessWidget {
  final int stepNumber;
  final String title;
  final bool isActive;
  final bool isCompleted;

  const ProgressStepWidget({
    Key? key,
    required this.stepNumber,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFFFDFDFD)
                : isActive
                    ? const Color(0xFFFDFDFD)
                    : const Color(0xFF282828),
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFFFDFDFD)
                  : const Color(0xFF282828),
              width: 1,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: const Color(0xFF141414),
                    size: 4.w,
                  )
                : Text(
                    stepNumber.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? const Color(0xFF141414)
                          : const Color(0xFFF1F1F1),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: isActive || isCompleted
                ? const Color(0xFFF1F1F1)
                : const Color(0xFFF1F1F1).withAlpha(128),
          ),
        ),
      ],
    );
  }
}