
import '../../../core/app_export.dart';

class StyleCustomizationWidget extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final double qrSize;
  final String errorCorrectionLevel;
  final bool hasLogo;
  final Function(Color) onForegroundColorChanged;
  final Function(Color) onBackgroundColorChanged;
  final Function(double) onSizeChanged;
  final Function(String) onErrorCorrectionChanged;
  final Function(bool) onLogoToggled;

  const StyleCustomizationWidget({
    super.key,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.qrSize,
    required this.errorCorrectionLevel,
    required this.hasLogo,
    required this.onForegroundColorChanged,
    required this.onBackgroundColorChanged,
    required this.onSizeChanged,
    required this.onErrorCorrectionChanged,
    required this.onLogoToggled,
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
                'Style Customization',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.palette_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          
          // Color Picker Section
          Text(
            'Colors',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildColorPicker(
                  'Foreground',
                  foregroundColor,
                  onForegroundColorChanged)),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildColorPicker(
                  'Background',
                  backgroundColor,
                  onBackgroundColorChanged)),
            ]),
          SizedBox(height: 20.h),
          
          // Size Slider
          Text(
            'Size: ${qrSize.toInt()}x${qrSize.toInt()}',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.accent,
              inactiveTrackColor: AppTheme.border,
              thumbColor: AppTheme.primaryAction,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              thumbShape: RoundSliderThumbShape(),
            ),
            child: Slider(
              value: qrSize,
              min: 100,
              max: 400,
              divisions: 30,
              onChanged: onSizeChanged)),
          SizedBox(height: 20.h),
          
          // Error Correction Level
          Text(
            'Error Correction Level',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _buildErrorCorrectionButton('L', 'Low (~7%)', errorCorrectionLevel == 'L')),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildErrorCorrectionButton('M', 'Medium (~15%)', errorCorrectionLevel == 'M')),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildErrorCorrectionButton('Q', 'Quartile (~25%)', errorCorrectionLevel == 'Q')),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildErrorCorrectionButton('H', 'High (~30%)', errorCorrectionLevel == 'H')),
            ]),
          SizedBox(height: 20.h),
          
          // Logo Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Logo',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Switch(
                value: hasLogo,
                onChanged: onLogoToggled,
                activeColor: AppTheme.accent,
                inactiveThumbColor: AppTheme.secondaryText,
                inactiveTrackColor: AppTheme.border),
            ]),
          if (hasLogo) ...[
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                // Open logo picker
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  
                  border: Border.all(
                    color: AppTheme.border,
                    width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_rounded,
                      color: AppTheme.secondaryText,
                      size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Upload Logo',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppTheme.secondaryText)),
                  ]))),
          ],
        ],
      ),
    );
  }

  Widget _buildColorPicker(String label, Color color, Function(Color) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.secondaryText)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            // Open color picker
          },
          child: Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              
              border: Border.all(
                color: AppTheme.border,
                width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.colorize_rounded,
                  color: color == AppTheme.primaryAction ? AppTheme.primaryBackground : AppTheme.primaryAction,
                  size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  'Pick Color',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: color == AppTheme.primaryAction ? AppTheme.primaryBackground : AppTheme.primaryAction)),
              ]))),
      ]);
  }

  Widget _buildErrorCorrectionButton(String level, String description, bool isSelected) {
    return GestureDetector(
      onTap: () => onErrorCorrectionChanged(level),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.accent : AppTheme.primaryText)),
            SizedBox(height: 2.h),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                color: isSelected ? AppTheme.accent : AppTheme.secondaryText),
              textAlign: TextAlign.center,
            ),
          ])));
  }
}