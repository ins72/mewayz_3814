import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ConversionFunnelWidget extends StatelessWidget {
  final String dateRange;

  const ConversionFunnelWidget({
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
                'Conversion Funnel',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.analytics_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Text(
            'User Journey from Click to Action',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 20.h),
          _buildFunnelStep(
            'Bio Page Views',
            '12,458',
            '100%',
            1.0,
            AppTheme.accent,
            isFirst: true),
          _buildFunnelStep(
            'Link Clicks',
            '8,742',
            '70.2%',
            0.7,
            AppTheme.success),
          _buildFunnelStep(
            'Page Visits',
            '6,234',
            '50.0%',
            0.5,
            AppTheme.warning),
          _buildFunnelStep(
            'Conversions',
            '3,091',
            '24.8%',
            0.248,
            AppTheme.error,
            isLast: true),
          SizedBox(height: 16.h),
          _buildFunnelInsights(),
        ]));
  }

  Widget _buildFunnelStep(
    String title,
    String value,
    String percentage,
    double width,
    Color color, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText)),
              Row(
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText)),
                  SizedBox(width: 8.w),
                  Text(
                    percentage,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.secondaryText)),
                ]),
            ]),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 8.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: width,
              child: Container(
                decoration: BoxDecoration(
                  color: color)))),
          if (!isLast) ...[
            SizedBox(height: 8.h),
            Center(
              child: Icon(
                Icons.arrow_downward_rounded,
                color: AppTheme.secondaryText,
                size: 16.sp)),
          ],
        ]));
  }

  Widget _buildFunnelInsights() {
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
          Text(
            'Funnel Insights',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 8.h),
          _buildInsightItem(
            'Highest drop-off occurs at Link Clicks stage',
            '29.8% of users don\'t click any links',
            AppTheme.warning),
          _buildInsightItem(
            'Strong conversion rate from visits to actions',
            '49.6% of page visitors complete desired actions',
            AppTheme.success),
          _buildInsightItem(
            'Overall conversion rate is above industry average',
            '24.8% vs 18.5% industry benchmark',
            AppTheme.accent),
        ]));
  }

  Widget _buildInsightItem(String title, String description, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            margin: EdgeInsets.only(top: 6.h),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle)),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText)),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppTheme.secondaryText)),
              ])),
        ]));
  }
}