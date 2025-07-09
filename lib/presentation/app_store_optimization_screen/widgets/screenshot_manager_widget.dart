import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ScreenshotManagerWidget extends StatefulWidget {
  const ScreenshotManagerWidget({super.key});

  @override
  State<ScreenshotManagerWidget> createState() => _ScreenshotManagerWidgetState();
}

class _ScreenshotManagerWidgetState extends State<ScreenshotManagerWidget> {
  final List<Map<String, dynamic>> _screenshots = [
{ 'device': 'iPhone 15 Pro',
'size': '1179x2556',
'uploaded': true,
'url': 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400',
},
{ 'device': 'iPhone 15 Pro Max',
'size': '1290x2796',
'uploaded': false,
'url': null,
},
{ 'device': 'iPad Pro 12.9"',
'size': '2048x2732',
'uploaded': true,
'url': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400',
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Screenshot Manager',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Upload screenshot
                },
                icon: const Icon(Icons.upload, color: Colors.white),
                label: Text(
                  'Upload',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...(_screenshots.map((screenshot) => _buildScreenshotItem(screenshot))),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screenshot Guidelines',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Use high-quality images that showcase your app\n'
                  '• Include captions or text overlays to explain features\n'
                  '• Show diverse content and use cases\n'
                  '• Avoid including personal information',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotItem(Map<String, dynamic> screenshot) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: screenshot['uploaded']
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      screenshot['url'],
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.add_photo_alternate,
                    color: Colors.grey[400],
                    size: 24.sp,
                  ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenshot['device'],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  screenshot['size'],
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      screenshot['uploaded'] ? Icons.check_circle : Icons.warning,
                      color: screenshot['uploaded'] ? Colors.green : Colors.orange,
                      size: 16.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      screenshot['uploaded'] ? 'Uploaded' : 'Required',
                      style: GoogleFonts.inter(
                        color: screenshot['uploaded'] ? Colors.green : Colors.orange,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Edit or replace screenshot
            },
            icon: Icon(
              screenshot['uploaded'] ? Icons.edit : Icons.upload,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}