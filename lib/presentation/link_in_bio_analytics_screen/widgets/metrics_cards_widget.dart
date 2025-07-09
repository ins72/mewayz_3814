import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MetricsCardsWidget extends StatelessWidget {
  final String dateRange;

  const MetricsCardsWidget({
    super.key,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMetricCard(
            'Total Clicks',
            '12,458',
            '+15.2%',
            Icons.mouse_rounded,
            AppTheme.accent,
            true),
          SizedBox(width: 16.w),
          _buildMetricCard(
            'Unique Visitors',
            '8,742',
            '+8.7%',
            Icons.people_rounded,
            AppTheme.success,
            true),
          SizedBox(width: 16.w),
          _buildMetricCard(
            'Conversion Rate',
            '24.8%',
            '+2.3%',
            Icons.trending_up_rounded,
            AppTheme.warning,
            true),
          SizedBox(width: 16.w),
          _buildMetricCard(
            'Top Link',
            'Instagram',
            '2,456 clicks',
            Icons.link_rounded,
            AppTheme.primaryAction,
            false),
        ]));
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool showTrend) {
    return Container(
      width: 160.w,
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
              Icon(
                icon,
                color: color,
                size: 24.sp),
              if (showTrend)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: AppTheme.success,
                        size: 12.sp),
                      SizedBox(width: 2.w),
                      Text(
                        change,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.success)),
                    ])),
            ]),
          SizedBox(height: 12.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryText)),
          SizedBox(height: 4.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.secondaryText)),
          if (!showTrend) ...[
            SizedBox(height: 4.h),
            Text(
              change,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppTheme.secondaryText)),
          ],
        ]));
  }
}