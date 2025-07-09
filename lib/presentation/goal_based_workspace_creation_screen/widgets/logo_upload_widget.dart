import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LogoUploadWidget extends StatefulWidget {
  final Function(String?) onLogoChanged;

  const LogoUploadWidget({
    Key? key,
    required this.onLogoChanged,
  }) : super(key: key);

  @override
  State<LogoUploadWidget> createState() => _LogoUploadWidgetState();
}

class _LogoUploadWidgetState extends State<LogoUploadWidget> {
  String? _logoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workspace Logo',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Upload your workspace logo (optional)',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 2.h),
        
        GestureDetector(
          onTap: _selectLogo,
          child: Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1,
              ),
            ),
            child: _logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildUploadPlaceholder();
                      },
                    ),
                  )
                : _buildUploadPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: const Color(0xFFF1F1F1).withAlpha(128),
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        Text(
          'Click to upload logo',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'PNG, JPG up to 5MB',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: const Color(0xFFF1F1F1).withAlpha(128),
          ),
        ),
      ],
    );
  }

  void _selectLogo() {
    // For demo purposes, using a placeholder image
    // In a real app, this would open file picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Select Logo',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose from sample logos or upload your own',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFFF1F1F1).withAlpha(179),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSampleLogo('https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop'),
                _buildSampleLogo('https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=200&h=200&fit=crop'),
                _buildSampleLogo('https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=200&h=200&fit=crop'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1).withAlpha(179),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _logoUrl = null;
              });
              widget.onLogoChanged(null);
              Navigator.pop(context);
            },
            child: Text(
              'Remove Logo',
              style: GoogleFonts.inter(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleLogo(String imageUrl) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _logoUrl = imageUrl;
        });
        widget.onLogoChanged(imageUrl);
        Navigator.pop(context);
      },
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}