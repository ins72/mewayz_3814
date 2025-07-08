import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../content_calendar_screen.dart';

class CalendarHeaderWidget extends StatelessWidget {
  final CalendarView currentView;
  final Function(CalendarView) onViewChanged;

  const CalendarHeaderWidget({
    Key? key,
    required this.currentView,
    required this.onViewChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xFF282828),
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _buildViewButton(
              'Month', CalendarView.month, Icons.calendar_view_month),
          _buildViewButton('Week', CalendarView.week, Icons.calendar_view_week),
          _buildViewButton('Day', CalendarView.day, Icons.calendar_today),
        ]));
  }

  Widget _buildViewButton(String title, CalendarView view, IconData icon) {
    final isSelected = currentView == view;

    return GestureDetector(
        onTap: () => onViewChanged(view),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFFDFDFD) : Colors.transparent,
                borderRadius: BorderRadius.circular(6)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              CustomIconWidget(
                  iconName: icon.codePoint.toString(),
                  size: 16,
                  color: isSelected
                      ? const Color(0xFF141414)
                      : const Color(0xFFF1F1F1)),
              SizedBox(width: 1.w),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF141414)
                          : const Color(0xFFF1F1F1))),
            ])));
  }
}
