import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TemplateLibraryWidget extends StatelessWidget {
  final String selectedTemplate;
  final Function(String) onTemplateSelected;

  const TemplateLibraryWidget({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateSelected,
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
                'Template Library',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.dashboard_customize_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Text(
            'Pre-designed QR code styles for different use cases',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 16.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.2,
            children: [
              _buildTemplateCard(
                'basic',
                'Basic',
                'Simple black and white QR code',
                Icons.qr_code_rounded,
                AppTheme.primaryBackground),
              _buildTemplateCard(
                'business',
                'Business Cards',
                'Professional style with border',
                Icons.business_center_rounded,
                AppTheme.accent),
              _buildTemplateCard(
                'social',
                'Social Media',
                'Colorful design for social sharing',
                Icons.share_rounded,
                AppTheme.success),
              _buildTemplateCard(
                'event',
                'Events',
                'Eye-catching design for events',
                Icons.event_rounded,
                AppTheme.warning),
              _buildTemplateCard(
                'marketing',
                'Marketing',
                'Bold style for campaigns',
                Icons.campaign_rounded,
                AppTheme.error),
              _buildTemplateCard(
                'restaurant',
                'Restaurant',
                'Menu and table service',
                Icons.restaurant_rounded,
                AppTheme.accent),
            ]),
        ]));
  }

  Widget _buildTemplateCard(
    String templateId,
    String title,
    String description,
    IconData icon,
    Color color) {
    final isSelected = selectedTemplate == templateId;
    return GestureDetector(
      onTap: () => onTemplateSelected(templateId),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? color : AppTheme.border,
            width: isSelected ? 2 : 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1)),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20.sp)),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: color,
                    size: 20.sp),
              ]),
            SizedBox(height: 8.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppTheme.primaryText)),
            SizedBox(height: 4.h),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          ])));
  }
}