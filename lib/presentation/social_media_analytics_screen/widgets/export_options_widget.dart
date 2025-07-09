import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String dateRange;
  final Function(String) onExport;

  const ExportOptionsWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Export Reports',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildExportOptions(),
          const SizedBox(height: 16),
          _buildScheduledReports(),
        ],
      ),
    );
  }

  Widget _buildExportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Export Format',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildExportCard(
                'PDF Report',
                'Complete analytics report',
                Icons.picture_as_pdf,
                AppTheme.error,
                () => onExport('pdf'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportCard(
                'Excel Data',
                'Raw data for analysis',
                Icons.table_chart,
                AppTheme.success,
                () => onExport('excel'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildExportCard(
                'CSV Export',
                'Simple data format',
                Icons.description,
                AppTheme.warning,
                () => onExport('csv'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportCard(
                'PowerPoint',
                'Presentation slides',
                Icons.slideshow,
                AppTheme.accent,
                () => onExport('ppt'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scheduled Reports',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildScheduleOption('Daily Report', 'Every day at 9:00 AM', false),
        _buildScheduleOption('Weekly Report', 'Every Monday at 8:00 AM', true),
        _buildScheduleOption('Monthly Report', 'First day of each month', true),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _createScheduledReport,
            icon: const Icon(Icons.schedule, size: 18),
            label: const Text('Create Scheduled Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: const Color(0xFF141414),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleOption(String title, String schedule, bool isEnabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schedule,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => _toggleSchedule(title, value),
            activeColor: AppTheme.accent,
          ),
        ],
      ),
    );
  }

  void _createScheduledReport() {
    // Show create scheduled report dialog
  }

  void _toggleSchedule(String reportType, bool enabled) {
    // Toggle scheduled report
  }
}