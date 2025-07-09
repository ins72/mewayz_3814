import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class GeographicAnalyticsWidget extends StatelessWidget {
  final String dateRange;

  const GeographicAnalyticsWidget({
    super.key,
    required this.dateRange,
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
                'Geographic Analytics',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.public_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              
              border: Border.all(
                color: AppTheme.border,
                width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_rounded,
                  color: AppTheme.secondaryText,
                  size: 48.sp),
                SizedBox(height: 8.h),
                Text(
                  'Interactive Map',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.secondaryText)),
                SizedBox(height: 4.h),
                Text(
                  'Visitor locations visualization',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.secondaryText)),
              ])),
          SizedBox(height: 16.h),
          Text(
            'Top Locations',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          _buildLocationRow('🇺🇸 United States', '3,456', '28.7%'),
          _buildLocationRow('🇬🇧 United Kingdom', '2,134', '17.8%'),
          _buildLocationRow('🇨🇦 Canada', '1,567', '13.0%'),
          _buildLocationRow('🇦🇺 Australia', '1,234', '10.3%'),
          _buildLocationRow('🇩🇪 Germany', '987', '8.2%'),
          _buildLocationRow('🇫🇷 France', '765', '6.4%'),
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)),
              child: Text(
                'View All Countries',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500)))),
        ]));
  }

  Widget _buildLocationRow(String location, String visitors, String percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              location,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText))),
          Expanded(
            flex: 2,
            child: Text(
              visitors,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText),
              textAlign: TextAlign.center)),
          Expanded(
            flex: 1,
            child: Text(
              percentage,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.secondaryText),
              textAlign: TextAlign.right)),
        ]));
  }
}