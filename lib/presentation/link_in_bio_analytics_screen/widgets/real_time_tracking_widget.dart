import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RealTimeTrackingWidget extends StatelessWidget {
  const RealTimeTrackingWidget({super.key});

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
                'Real-Time Tracking',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle)),
                    SizedBox(width: 4.w),
                    Text(
                      'Live',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.success)),
                  ])),
            ]),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildRealTimeMetric(
                  'Active Users',
                  '47',
                  Icons.people_outline_rounded,
                  AppTheme.success)),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildRealTimeMetric(
                  'Page Views',
                  '156',
                  Icons.visibility_rounded,
                  AppTheme.accent)),
            ]),
          SizedBox(height: 16.h),
          Text(
            'Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          _buildActivityItem('New York, US', 'Clicked Instagram link', '2 seconds ago'),
          _buildActivityItem('London, UK', 'Viewed bio page', '12 seconds ago'),
          _buildActivityItem('Toronto, CA', 'Clicked YouTube link', '23 seconds ago'),
          _buildActivityItem('Sydney, AU', 'Viewed bio page', '45 seconds ago'),
          _buildActivityItem('Berlin, DE', 'Clicked portfolio link', '1 minute ago'),
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)),
              child: Text(
                'View All Activity',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500)))),
        ]));
  }

  Widget _buildRealTimeMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        
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
                size: 20.sp),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle)),
            ]),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryText)),
          SizedBox(height: 4.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.secondaryText)),
        ]));
  }

  Widget _buildActivityItem(String location, String action, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText)),
                Text(
                  action,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.secondaryText)),
              ])),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppTheme.secondaryText)),
        ]));
  }
}