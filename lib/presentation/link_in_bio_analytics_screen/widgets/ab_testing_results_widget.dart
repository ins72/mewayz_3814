import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ABTestingResultsWidget extends StatelessWidget {
  final String dateRange;

  const ABTestingResultsWidget({
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
                'A/B Testing Results',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.science_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Text(
            'Active Tests',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          _buildTestResult(
            'Button Color Test',
            'Blue vs Green CTA buttons',
            'A',
            '12.4%',
            'B',
            '18.7%',
            51.2,
            AppTheme.success,
            'Variant B is winning'),
          SizedBox(height: 16.h),
          _buildTestResult(
            'Layout Test',
            'Grid vs List layout',
            'A',
            '24.8%',
            'B',
            '22.1%',
            12.2,
            AppTheme.warning,
            'No significant difference'),
          SizedBox(height: 16.h),
          Text(
            'Completed Tests',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          _buildCompletedTest(
            'Headline Test',
            'Short vs Long headlines',
            'Short headlines increased clicks by 23%',
            AppTheme.success),
          _buildCompletedTest(
            'Image Test',
            'Personal vs Brand images',
            'Personal images performed 15% better',
            AppTheme.accent),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'Create New Test',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'View All Tests',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
            ]),
        ]));
  }

  Widget _buildTestResult(
    String title,
    String description,
    String variantA,
    String rateA,
    String variantB,
    String rateB,
    double confidence,
    Color statusColor,
    String status) {
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
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1)),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: statusColor))),
            ]),
          SizedBox(height: 4.h),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildVariantResult(variantA, rateA, false)),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildVariantResult(variantB, rateB, true)),
            ]),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confidence: ${confidence.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.secondaryText)),
              Text(
                'Statistical significance: ${confidence > 95 ? 'Yes' : 'No'}',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: confidence > 95 ? AppTheme.success : AppTheme.warning)),
            ]),
        ]));
  }

  Widget _buildVariantResult(String variant, String rate, bool isWinning) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isWinning ? AppTheme.success.withValues(alpha: 0.1) : AppTheme.surface,
        
        border: Border.all(
          color: isWinning ? AppTheme.success : AppTheme.border,
          width: 1)),
      child: Column(
        children: [
          Text(
            'Variant $variant',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText)),
          SizedBox(height: 4.h),
          Text(
            rate,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isWinning ? AppTheme.success : AppTheme.primaryText)),
          if (isWinning) ...[
            SizedBox(height: 4.h),
            Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 16.sp),
          ],
        ]));
  }

  Widget _buildCompletedTest(String title, String description, String result, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
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
                Text(
                  result,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: color)),
              ])),
        ]));
  }
}