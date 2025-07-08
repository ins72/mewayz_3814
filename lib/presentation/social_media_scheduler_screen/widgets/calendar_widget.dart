import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CalendarWidget extends StatefulWidget {
  final bool isMonthView;
  final DateTime selectedDate;
  final List<Map<String, dynamic>> scheduledPosts;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    Key? key,
    required this.isMonthView,
    required this.selectedDate,
    required this.scheduledPosts,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;
  late DateTime _currentWeek;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _currentWeek = _getWeekStart(widget.selectedDate);
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    final endDate = lastDay.add(Duration(days: 7 - lastDay.weekday));

    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List<DateTime> _getDaysInWeek(DateTime weekStart) {
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  List<Map<String, dynamic>> _getPostsForDate(DateTime date) {
    return widget.scheduledPosts.where((post) {
      final postDate = post['scheduledDate'] as DateTime;
      return postDate.year == date.year &&
          postDate.month == date.month &&
          postDate.day == date.day;
    }).toList();
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
              HapticFeedback.selectionClick();
            },
            icon: Icon(
              Icons.chevron_left,
              color: Color(0xFFF1F1F1),
              size: 24.sp,
            ),
          ),
          Text(
            "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF1F1F1),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
              HapticFeedback.selectionClick();
            },
            icon: Icon(
              Icons.chevron_right,
              color: Color(0xFFF1F1F1),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentWeek = _currentWeek.subtract(Duration(days: 7));
              });
              HapticFeedback.selectionClick();
            },
            icon: Icon(
              Icons.chevron_left,
              color: Color(0xFFF1F1F1),
              size: 24.sp,
            ),
          ),
          Text(
            "Week of ${_currentWeek.day} ${_getMonthName(_currentWeek.month)}",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF1F1F1),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentWeek = _currentWeek.add(Duration(days: 7));
              });
              HapticFeedback.selectionClick();
            },
            icon: Icon(
              Icons.chevron_right,
              color: Color(0xFFF1F1F1),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayNamesHeader() {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: dayNames
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, bool isCurrentMonth) {
    final dayPosts = _getPostsForDate(date);
    final isSelected = widget.selectedDate.day == date.day &&
        widget.selectedDate.month == date.month &&
        widget.selectedDate.year == date.year;
    final isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;

    return GestureDetector(
      onTap: () {
        widget.onDateSelected(date);
        HapticFeedback.selectionClick();
      },
      child: Container(
        height: widget.isMonthView ? 12.h : 15.h,
        margin: EdgeInsets.all(1.sp),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF282828) : Color(0xFF191919),
          borderRadius: BorderRadius.circular(8.sp),
          border:
              isToday ? Border.all(color: Color(0xFFFDFDFD), width: 1) : null,
        ),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Text(
              date.day.toString(),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isCurrentMonth ? Color(0xFFF1F1F1) : Color(0xFF7B7B7B),
              ),
            ),
            SizedBox(height: 0.5.h),
            Expanded(
              child: widget.isMonthView
                  ? _buildPostDots(dayPosts)
                  : _buildPostPreviews(dayPosts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostDots(List<Map<String, dynamic>> posts) {
    if (posts.isEmpty) return SizedBox();

    return Wrap(
      spacing: 2.sp,
      runSpacing: 2.sp,
      children: posts
          .take(4)
          .map((post) => Container(
                width: 6.sp,
                height: 6.sp,
                decoration: BoxDecoration(
                  color: post['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPostPreviews(List<Map<String, dynamic>> posts) {
    if (posts.isEmpty) return SizedBox();

    return Column(
      children: posts
          .take(2)
          .map((post) => Container(
                width: double.infinity,
                height: 3.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Color(0xFF282828),
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4.sp,
                      height: 4.sp,
                      decoration: BoxDecoration(
                        color: post['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        post['content'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Color(0xFFF1F1F1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Color(0xFF282828)),
      ),
      child: Column(
        children: [
          widget.isMonthView ? _buildMonthHeader() : _buildWeekHeader(),
          _buildDayNamesHeader(),
          Container(
            padding: EdgeInsets.all(2.w),
            child: widget.isMonthView
                ? Column(
                    children: _getDaysInMonth(_currentMonth)
                        .asMap()
                        .entries
                        .where((entry) => entry.key % 7 == 0)
                        .map((entry) {
                      final weekStart = entry.key;
                      final weekDays = _getDaysInMonth(_currentMonth)
                          .skip(weekStart)
                          .take(7)
                          .toList();
                      return Row(
                        children: weekDays
                            .map((date) => Expanded(
                                  child: _buildDayCell(
                                    date,
                                    date.month == _currentMonth.month,
                                  ),
                                ))
                            .toList(),
                      );
                    }).toList(),
                  )
                : Row(
                    children: _getDaysInWeek(_currentWeek)
                        .map((date) => Expanded(
                              child: _buildDayCell(date, true),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
