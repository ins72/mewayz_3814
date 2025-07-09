import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class UrlInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(bool) onValidationChanged;

  const UrlInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onValidationChanged,
  });

  @override
  State<UrlInputWidget> createState() => _UrlInputWidgetState();
}

class _UrlInputWidgetState extends State<UrlInputWidget> {
  bool isValid = true;
  String? errorMessage;

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
                'URL Input',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.link_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              _validateUrl(value);
              widget.onChanged(value);
            },
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.primaryText),
            decoration: InputDecoration(
              hintText: 'Enter URL or bio link destination',
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.secondaryText),
              prefixIcon: Icon(
                Icons.link_rounded,
                color: AppTheme.secondaryText,
                size: 20.sp),
              suffixIcon: isValid
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.success,
                      size: 20.sp)
                  : Icon(
                      Icons.error_rounded,
                      color: AppTheme.error,
                      size: 20.sp),
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
                  width: 2)),
              errorBorder: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 1)),
              errorText: errorMessage),
            maxLines: 2,
            keyboardType: TextInputType.url),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickLinkButton(
                  'Bio Link',
                  Icons.person_rounded,
                  () => _setQuickUrl('https://mewayz.com/bio/username'))),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildQuickLinkButton(
                  'Website',
                  Icons.public_rounded,
                  () => _setQuickUrl('https://example.com'))),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildQuickLinkButton(
                  'Social',
                  Icons.share_rounded,
                  () => _setQuickUrl('https://instagram.com/username'))),
            ]),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              
              border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.3),
                width: 1)),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppTheme.accent,
                  size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'QR codes will automatically track clicks and provide analytics',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.accent))),
              ])),
        ]));
  }

  Widget _buildQuickLinkButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          
          border: Border.all(
            color: AppTheme.border,
            width: 1)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.secondaryText,
              size: 16.sp),
            SizedBox(height: 4.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppTheme.secondaryText)),
          ])));
  }

  void _validateUrl(String url) {
    if (url.isEmpty) {
      setState(() {
        isValid = false;
        errorMessage = 'URL cannot be empty';
      });
      widget.onValidationChanged(false);
      return;
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false);

    if (!urlRegex.hasMatch(url)) {
      setState(() {
        isValid = false;
        errorMessage = 'Please enter a valid URL';
      });
      widget.onValidationChanged(false);
      return;
    }

    setState(() {
      isValid = true;
      errorMessage = null;
    });
    widget.onValidationChanged(true);
  }

  void _setQuickUrl(String url) {
    widget.controller.text = url;
    _validateUrl(url);
    widget.onChanged(url);
  }
}