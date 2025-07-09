
import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatefulWidget {
  final Function(String format, List<String> metrics) onExport;

  const ExportOptionsWidget({
    super.key,
    required this.onExport,
  });

  @override
  State<ExportOptionsWidget> createState() => _ExportOptionsWidgetState();
}

class _ExportOptionsWidgetState extends State<ExportOptionsWidget> {
  String selectedFormat = 'pdf';
  List<String> selectedMetrics = ['clicks', 'visitors', 'conversion'];

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
                'Export Analytics',
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
          Text(
            'Export Format',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildFormatOption('pdf', 'PDF Report', Icons.picture_as_pdf_rounded)),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFormatOption('csv', 'CSV Data', Icons.table_chart_rounded)),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFormatOption('excel', 'Excel File', Icons.file_present_rounded)),
            ]),
          SizedBox(height: 24.h),
          Text(
            'Select Metrics',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          SizedBox(height: 12.h),
          _buildMetricCheckbox('clicks', 'Total Clicks'),
          _buildMetricCheckbox('visitors', 'Unique Visitors'),
          _buildMetricCheckbox('conversion', 'Conversion Rate'),
          _buildMetricCheckbox('geography', 'Geographic Data'),
          _buildMetricCheckbox('devices', 'Device Analytics'),
          _buildMetricCheckbox('traffic', 'Traffic Sources'),
          _buildMetricCheckbox('realtime', 'Real-time Data'),
          _buildMetricCheckbox('funnel', 'Conversion Funnel'),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedMetrics.isNotEmpty
                      ? () {
                          widget.onExport(selectedFormat, selectedMetrics);
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'Export',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
            ]),
          SizedBox(height: 20.h),
        ]));
  }

  Widget _buildFormatOption(String format, String label, IconData icon) {
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
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppTheme.accent : AppTheme.secondaryText),
              textAlign: TextAlign.center),
          ])));
  }

  Widget _buildMetricCheckbox(String metric, String label) {
    final isSelected = selectedMetrics.contains(metric);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedMetrics.remove(metric);
                } else {
                  selectedMetrics.add(metric);
                }
              });
            },
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : Colors.transparent,
                
                border: Border.all(
                  color: isSelected ? AppTheme.accent : AppTheme.border,
                  width: 1)),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: AppTheme.primaryAction,
                      size: 14.sp)
                  : null)),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.primaryText)),
        ]));
  }
}