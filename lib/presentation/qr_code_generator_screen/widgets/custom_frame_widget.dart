import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomFrameWidget extends StatelessWidget {
  final String selectedFrame;
  final String callToActionText;
  final Function(String) onFrameChanged;
  final Function(String) onCallToActionChanged;

  const CustomFrameWidget({
    super.key,
    required this.selectedFrame,
    required this.callToActionText,
    required this.onFrameChanged,
    required this.onCallToActionChanged,
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
                'Custom Frame Options',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.border_style_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Text(
            'Add decorative borders and call-to-action text',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 16.h),
          
          // Frame Selection
          Text(
            'Frame Style',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.5,
            children: [
              _buildFrameOption('none', 'No Frame', Icons.crop_free_rounded, AppTheme.secondaryText),
              _buildFrameOption('basic', 'Basic Border', Icons.border_outer_rounded, AppTheme.accent),
              _buildFrameOption('rounded', 'Rounded', Icons.rounded_corner_rounded, AppTheme.success),
              _buildFrameOption('business', 'Business', Icons.business_center_rounded, AppTheme.warning),
              _buildFrameOption('social', 'Social', Icons.share_rounded, AppTheme.error),
              _buildFrameOption('event', 'Event', Icons.event_rounded, AppTheme.accent),
            ]),
          SizedBox(height: 20.h),
          
          // Call to Action Text
          Text(
            'Call to Action Text',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 8.h),
          TextFormField(
            initialValue: callToActionText,
            onChanged: onCallToActionChanged,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.primaryText),
            decoration: InputDecoration(
              hintText: 'Enter call to action text (optional)',
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.secondaryText),
              filled: true,
              fillColor: AppTheme.primaryBackground,
              border: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1)),
              enabledBorder: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1)),
              focusedBorder: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.accent,
                  width: 2))),
            maxLength: 50),
          SizedBox(height: 16.h),
          
          // Quick CTA Suggestions
          Text(
            'Quick Suggestions',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildSuggestionChip('Scan Me'),
              _buildSuggestionChip('Visit Website'),
              _buildSuggestionChip('Get Info'),
              _buildSuggestionChip('Follow Us'),
              _buildSuggestionChip('Learn More'),
              _buildSuggestionChip('Contact Us'),
              _buildSuggestionChip('Special Offer'),
              _buildSuggestionChip('Menu'),
            ]),
          SizedBox(height: 16.h),
          
          // Frame Preview
          if (selectedFrame != 'none') ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.3),
                  width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frame Preview',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent)),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: AppTheme.accent,
                        size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Selected frame: ${_getFrameDescription(selectedFrame)}',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppTheme.accent))),
                    ]),
                  if (callToActionText.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Text: "$callToActionText"',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppTheme.accent)),
                  ],
                ])),
          ],
        ]));
  }

  Widget _buildFrameOption(String frame, String title, IconData icon, Color color) {
    final isSelected = selectedFrame == frame;
    return GestureDetector(
      onTap: () => onFrameChanged(frame),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? color : AppTheme.border,
            width: isSelected ? 2 : 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppTheme.secondaryText,
              size: 20.sp),
            SizedBox(height: 4.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : AppTheme.secondaryText),
              textAlign: TextAlign.center),
          ])));
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => onCallToActionChanged(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          
          border: Border.all(
            color: AppTheme.border,
            width: 1)),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.primaryText))));
  }

  String _getFrameDescription(String frame) {
    switch (frame) {
      case 'basic':
        return 'Simple border frame';
      case 'rounded':
        return 'Rounded corner frame';
      case 'business':
        return 'Professional business frame';
      case 'social':
        return 'Social media style frame';
      case 'event':
        return 'Event promotion frame';
      default:
        return 'No frame selected';
    }
  }
}