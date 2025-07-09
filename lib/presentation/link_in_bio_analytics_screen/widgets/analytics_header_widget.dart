import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnalyticsHeaderWidget extends StatelessWidget {
  final String selectedDateRange;
  final Function(String) onDateRangeChanged;

  const AnalyticsHeaderWidget({
    super.key,
    required this.selectedDateRange,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        
        border: Border.all(
          color: AppTheme.border,
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Overview',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.trending_up_rounded,
                color: AppTheme.success,
                size: 24.sp),
            ]),
          SizedBox(height: 12.h),
          Text(
            'Track your Link in Bio performance with detailed analytics',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                'Date Range:',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText)),
              SizedBox(width: 12.w),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDateRangeChip('24h', 'Last 24 Hours'),
                      SizedBox(width: 8.w),
                      _buildDateRangeChip('7d', '7 Days'),
                      SizedBox(width: 8.w),
                      _buildDateRangeChip('30d', '30 Days'),
                      SizedBox(width: 8.w),
                      _buildDateRangeChip('90d', '90 Days'),
                      SizedBox(width: 8.w),
                      _buildDateRangeChip('1y', '1 Year'),
                    ]))),
            ]),
        ]));
  }

  Widget _buildDateRangeChip(String value, String label) {
    final isSelected = selectedDateRange == value;
    return GestureDetector(
      onTap: () => onDateRangeChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText))));
  }
}