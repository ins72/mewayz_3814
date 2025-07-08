import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeChanged;

  const DateRangeSelectorWidget({
    Key? key,
    required this.selectedRange,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> dateRanges = [
      'Last 7 days',
      'Last 30 days',
      'Last 90 days',
      'Custom Range'
    ];

    return GestureDetector(
      onTap: () => _showDateRangeOptions(context, dateRanges),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              selectedRange,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangeOptions(BuildContext context, List<String> dateRanges) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date Range',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ...dateRanges.map((range) {
                return ListTile(
                  title: Text(
                    range,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  trailing: selectedRange == range
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.accent,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    if (range == 'Custom Range') {
                      Navigator.pop(context);
                      _showCustomDatePicker(context);
                    } else {
                      onRangeChanged(range);
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.surface,
              headerBackgroundColor: AppTheme.primaryBackground,
              headerForegroundColor: AppTheme.primaryText,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryBackground;
                }
                return AppTheme.primaryText;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.accent;
                }
                return Colors.transparent;
              }),
              todayForegroundColor: WidgetStateProperty.all(AppTheme.accent),
              rangeSelectionBackgroundColor:
                  AppTheme.accent.withValues(alpha: 0.3),
            ),
          ),
          child: child!,
        );
      },
    ).then((dateRange) {
      if (dateRange != null) {
        final startDate = dateRange.start;
        final endDate = dateRange.end;
        final customRange =
            '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
        onRangeChanged(customRange);
      }
    });
  }
}