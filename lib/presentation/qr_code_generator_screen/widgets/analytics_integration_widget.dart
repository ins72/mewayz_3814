import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnalyticsIntegrationWidget extends StatefulWidget {
  final String qrCodeUrl;

  const AnalyticsIntegrationWidget({
    super.key,
    required this.qrCodeUrl,
  });

  @override
  State<AnalyticsIntegrationWidget> createState() => _AnalyticsIntegrationWidgetState();
}

class _AnalyticsIntegrationWidgetState extends State<AnalyticsIntegrationWidget> {
  bool trackingEnabled = true;
  bool locationTracking = false;
  bool deviceTracking = true;

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
                'Analytics Integration',
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
            'Track QR code scan statistics and user behavior',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 16.h),
          
          // Tracking Options
          _buildTrackingOption(
            'Scan Tracking',
            'Track total scans and unique users',
            trackingEnabled,
            (value) {
              setState(() {
                trackingEnabled = value;
              });
            }),
          SizedBox(height: 12.h),
          _buildTrackingOption(
            'Device Analytics',
            'Track device types and platforms',
            deviceTracking,
            (value) {
              setState(() {
                deviceTracking = value;
              });
            }),
          SizedBox(height: 12.h),
          _buildTrackingOption(
            'Location Data',
            'Track geographic locations (requires permission)',
            locationTracking,
            (value) {
              setState(() {
                locationTracking = value;
              });
            }),
          SizedBox(height: 20.h),
          
          // Analytics Preview
          if (trackingEnabled) ...[
            Container(
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
                    'Analytics Preview',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText)),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnalyticsMetric(
                          'Total Scans',
                          '0',
                          Icons.qr_code_scanner_rounded,
                          AppTheme.accent)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildAnalyticsMetric(
                          'Unique Users',
                          '0',
                          Icons.people_rounded,
                          AppTheme.success)),
                    ]),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnalyticsMetric(
                          'Mobile',
                          '0%',
                          Icons.smartphone_rounded,
                          AppTheme.warning)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildAnalyticsMetric(
                          'Desktop',
                          '0%',
                          Icons.desktop_mac_rounded,
                          AppTheme.error)),
                    ]),
                ])),
            SizedBox(height: 16.h),
          ],
          
          // Analytics Settings
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showAnalyticsSettings(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings_rounded,
                        size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Settings',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500)),
                    ]))),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: trackingEnabled ? () => _viewAnalytics() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'View Analytics',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500)),
                    ]))),
            ]),
          SizedBox(height: 16.h),
          
          // Privacy Notice
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.warning.withValues(alpha: 0.1),
              
              border: Border.all(
                color: AppTheme.warning.withValues(alpha: 0.3),
                width: 1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.privacy_tip_rounded,
                  color: AppTheme.warning,
                  size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Analytics data is collected in compliance with privacy regulations. Users can opt-out at any time.',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppTheme.warning))),
              ])),
        ]));
  }

  Widget _buildTrackingOption(String title, String description, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText)),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.secondaryText)),
            ])),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
          inactiveThumbColor: AppTheme.secondaryText,
          inactiveTrackColor: AppTheme.border),
      ]);
  }

  Widget _buildAnalyticsMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1)),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color)),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: color)),
        ]));
  }

  void _showAnalyticsSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Analytics settings panel coming soon',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.accent.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder()));
  }

  void _viewAnalytics() {
    Navigator.pushNamed(context, '/link-in-bio-analytics-screen');
  }
}