
import '../../../core/app_export.dart';

class DownloadOptionsWidget extends StatefulWidget {
  final Function(String format, int resolution) onDownload;

  const DownloadOptionsWidget({
    super.key,
    required this.onDownload,
  });

  @override
  State<DownloadOptionsWidget> createState() => _DownloadOptionsWidgetState();
}

class _DownloadOptionsWidgetState extends State<DownloadOptionsWidget> {
  String selectedFormat = 'png';
  int selectedResolution = 1024;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Download Options',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppTheme.secondaryText,
                  size: 24.sp)),
            ]),
          SizedBox(height: 20.h),
          
          // Format Selection
          Text(
            'File Format',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildFormatOption(
                  'png',
                  'PNG',
                  'Best for digital use',
                  Icons.image_rounded)),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFormatOption(
                  'svg',
                  'SVG',
                  'Vector format',
                  Icons.auto_fix_high_rounded)),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFormatOption(
                  'pdf',
                  'PDF',
                  'Print ready',
                  Icons.picture_as_pdf_rounded)),
            ]),
          SizedBox(height: 24.h),
          
          // Resolution Selection (only for PNG)
          if (selectedFormat == 'png') ...[
            Text(
              'Resolution',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText)),
            SizedBox(height: 12.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.5,
              children: [
                _buildResolutionOption(512, '512x512', 'Web/Mobile'),
                _buildResolutionOption(1024, '1024x1024', 'Standard'),
                _buildResolutionOption(2048, '2048x2048', 'High Quality'),
                _buildResolutionOption(4096, '4096x4096', 'Print Ready'),
              ]),
            SizedBox(height: 24.h),
          ],
          
          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onDownload(selectedFormat, selectedResolution);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryAction,
                foregroundColor: AppTheme.primaryBackground,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_rounded,
                    size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Download QR Code',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)),
                ]))),
          SizedBox(height: 16.h),
          
          // Additional Options
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
                  'Download Features:',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent)),
                SizedBox(height: 4.h),
                Text(
                  '• Multiple formats supported\n• High resolution options\n• Transparent backgrounds\n• Print optimization',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppTheme.accent)),
              ])),
          SizedBox(height: 20.h),
        ]));
  }

  Widget _buildFormatOption(String format, String title, String description, IconData icon) {
    final isSelected = selectedFormat == format;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFormat = format;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
              size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.accent : AppTheme.primaryText)),
            SizedBox(height: 4.h),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: isSelected ? AppTheme.accent : AppTheme.secondaryText),
              textAlign: TextAlign.center),
          ])));
  }

  Widget _buildResolutionOption(int resolution, String size, String description) {
    final isSelected = selectedResolution == resolution;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedResolution = resolution;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              size,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.accent : AppTheme.primaryText)),
            SizedBox(height: 2.h),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: isSelected ? AppTheme.accent : AppTheme.secondaryText),
              textAlign: TextAlign.center),
          ])));
  }
}