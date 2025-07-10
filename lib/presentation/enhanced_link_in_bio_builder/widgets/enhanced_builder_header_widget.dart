import '../../../core/app_export.dart';

class EnhancedBuilderHeaderWidget extends StatelessWidget {
  final Map<String, dynamic>? currentPage;
  final bool isPreviewMode;
  final bool isSaving;
  final String selectedDevice;
  final VoidCallback onPreviewToggle;
  final Function(String) onDeviceChange;
  final VoidCallback onSave;
  final VoidCallback onPublish;
  final VoidCallback onDomainSettings;
  final VoidCallback onBack;

  const EnhancedBuilderHeaderWidget({
    Key? key,
    this.currentPage,
    required this.isPreviewMode,
    required this.isSaving,
    required this.selectedDevice,
    required this.onPreviewToggle,
    required this.onDeviceChange,
    required this.onSave,
    required this.onPublish,
    required this.onDomainSettings,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF101010),
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: AppTheme.primaryText),
            tooltip: 'Back to Dashboard',
          ),
          
          SizedBox(width: 16),
          
          // Page title and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentPage?['title'] ?? 'New Page',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      _getStatusText(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Device selector (in preview mode)
          if (isPreviewMode) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF191919),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDeviceOption('mobile', Icons.phone_android),
                  SizedBox(width: 8),
                  _buildDeviceOption('tablet', Icons.tablet_mac),
                  SizedBox(width: 8),
                  _buildDeviceOption('desktop', Icons.computer),
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
          
          // Domain settings button
          IconButton(
            onPressed: onDomainSettings,
            icon: Icon(Icons.language, color: AppTheme.primaryText),
            tooltip: 'Domain Settings',
          ),
          
          SizedBox(width: 8),
          
          // Preview toggle
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF191919),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeToggle('Edit', !isPreviewMode),
                _buildModeToggle('Preview', isPreviewMode),
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // Save button
          ElevatedButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAction),
                    ),
                  )
                : Icon(Icons.save, size: 16),
            label: Text(isSaving ? 'Saving...' : 'Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          
          SizedBox(width: 8),
          
          // Publish button
          ElevatedButton.icon(
            onPressed: currentPage?['status'] == 'published' ? null : onPublish,
            icon: Icon(
              currentPage?['status'] == 'published' ? Icons.cloud_done : Icons.publish,
              size: 16,
            ),
            label: Text(
              currentPage?['status'] == 'published' ? 'Published' : 'Publish',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage?['status'] == 'published' 
                  ? AppTheme.success 
                  : AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceOption(String device, IconData icon) {
    final isSelected = selectedDevice == device;
    return GestureDetector(
      onTap: () => onDeviceChange(device),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildModeToggle(String label, bool isSelected) {
    return GestureDetector(
      onTap: onPreviewToggle,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (currentPage?['status']) {
      case 'published':
        return AppTheme.success;
      case 'draft':
        return AppTheme.warning;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _getStatusText() {
    switch (currentPage?['status']) {
      case 'published':
        return 'Published';
      case 'draft':
        return 'Draft';
      default:
        return 'Unsaved';
    }
  }
}