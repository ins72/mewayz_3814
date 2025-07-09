
import '../../../core/app_export.dart';

class QRCodePreviewWidget extends StatelessWidget {
  final String url;
  final Color foregroundColor;
  final Color backgroundColor;
  final double size;
  final bool hasLogo;
  final String selectedFrame;
  final String callToActionText;

  const QRCodePreviewWidget({
    super.key,
    required this.url,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.size,
    required this.hasLogo,
    required this.selectedFrame,
    required this.callToActionText,
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
                'QR Code Preview',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.qr_code_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Center(
            child: Container(
              width: size.w + 40.w,
              height: size.h + (callToActionText.isNotEmpty ? 60.h : 40.h),
              decoration: BoxDecoration(
                color: backgroundColor,
                
                border: selectedFrame != 'none' ? Border.all(
                  color: _getFrameColor(),
                  width: 3) : null),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (callToActionText.isNotEmpty) ...[
                    Text(
                      callToActionText,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor)),
                    SizedBox(height: 8.h),
                  ],
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // QR Code placeholder
                      Container(
                        width: size.w,
                        height: size.h,
                        decoration: BoxDecoration(
                          color: backgroundColor),
                        child: CustomPaint(
                          painter: QRCodePainter(
                            foregroundColor: foregroundColor,
                            backgroundColor: backgroundColor))),
                      // Logo overlay
                      if (hasLogo)
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAction,
                            
                            border: Border.all(
                              color: backgroundColor,
                              width: 2)),
                          child: Icon(
                            Icons.business_rounded,
                            color: AppTheme.primaryBackground,
                            size: 24.sp)),
                    ]),
                ]))),
          SizedBox(height: 16.h),
          if (url.isNotEmpty) ...[
            Text(
              'URL: $url',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
            SizedBox(height: 8.h),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Size', '${size.toInt()}x${size.toInt()}'),
              _buildInfoItem('Format', 'PNG'),
              _buildInfoItem('Quality', 'High'),
            ]),
        ]));
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.secondaryText)),
      ]);
  }

  Color _getFrameColor() {
    switch (selectedFrame) {
      case 'business':
        return AppTheme.accent;
      case 'social':
        return AppTheme.success;
      case 'event':
        return AppTheme.warning;
      case 'marketing':
        return AppTheme.error;
      default:
        return AppTheme.border;
    }
  }
}

class QRCodePainter extends CustomPainter {
  final Color foregroundColor;
  final Color backgroundColor;

  QRCodePainter({
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 25;

    // Draw a simple QR code pattern
    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 25; j++) {
        // Create a pseudo-random pattern
        if ((i + j) % 3 == 0 || (i % 7 == 0 && j % 5 == 0)) {
          canvas.drawRect(
            Rect.fromLTWH(
              i * cellSize,
              j * cellSize,
              cellSize,
              cellSize),
            paint);
        }
      }
    }

    // Draw corner markers
    _drawCornerMarker(canvas, 0, 0, cellSize, paint);
    _drawCornerMarker(canvas, 18 * cellSize, 0, cellSize, paint);
    _drawCornerMarker(canvas, 0, 18 * cellSize, cellSize, paint);
  }

  void _drawCornerMarker(Canvas canvas, double x, double y, double cellSize, Paint paint) {
    // Outer square
    canvas.drawRect(
      Rect.fromLTWH(x, y, cellSize * 7, cellSize * 7),
      paint);
    
    // Inner white square
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5),
      Paint()..color = backgroundColor);
    
    // Center square
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3),
      paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}