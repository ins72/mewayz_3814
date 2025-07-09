import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LinkPerformanceWidget extends StatelessWidget {
  final String dateRange;
  final String filter;

  const LinkPerformanceWidget({
    super.key,
    required this.dateRange,
    required this.filter,
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
                'Link Performance',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.list_alt_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          _buildTableHeader(),
          SizedBox(height: 8.h),
          _buildLinkRow('Instagram Profile', '2,456', '28.5%', '89.2%'),
          _buildLinkRow('YouTube Channel', '1,890', '22.1%', '76.3%'),
          _buildLinkRow('Portfolio Website', '1,234', '14.4%', '91.7%'),
          _buildLinkRow('Email Contact', '987', '11.5%', '68.4%'),
          _buildLinkRow('LinkedIn Profile', '765', '8.9%', '82.1%'),
          _buildLinkRow('TikTok Profile', '543', '6.3%', '74.9%'),
          SizedBox(height: 16.h),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)),
              child: Text(
                'View All Links',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500)))),
        ]));
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Link',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText))),
        Expanded(
          flex: 2,
          child: Text(
            'Clicks',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText),
            textAlign: TextAlign.center)),
        Expanded(
          flex: 2,
          child: Text(
            'Share',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText),
            textAlign: TextAlign.center)),
        Expanded(
          flex: 2,
          child: Text(
            'CTR',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText),
            textAlign: TextAlign.center)),
      ]);
  }

  Widget _buildLinkRow(String title, String clicks, String share, String ctr) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 0.5))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    
                    border: Border.all(
                      color: AppTheme.border,
                      width: 1)),
                  child: Icon(
                    Icons.link_rounded,
                    color: AppTheme.secondaryText,
                    size: 16.sp)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppTheme.primaryText),
                    overflow: TextOverflow.ellipsis)),
              ])),
          Expanded(
            flex: 2,
            child: Text(
              clicks,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText),
              textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              share,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.secondaryText),
              textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              ctr,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.success),
              textAlign: TextAlign.center)),
        ]));
  }
}