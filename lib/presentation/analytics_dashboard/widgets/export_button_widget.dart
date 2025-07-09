
import '../../../core/app_export.dart';

class ExportButtonWidget extends StatelessWidget {
  final VoidCallback onExport;

  const ExportButtonWidget({
    Key? key,
    required this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onExport,
      icon: CustomIconWidget(
        iconName: 'file_download',
        color: AppTheme.primaryBackground,
        size: 18,
      ),
      label: Text(
        'Export',
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primaryBackground,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryAction,
        foregroundColor: AppTheme.primaryBackground,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    );
  }
}