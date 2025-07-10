import '../../../core/app_export.dart';

class BuilderHeaderWidget extends StatelessWidget {
  final Map<String, dynamic>? currentPage;
  final bool isPreviewMode;
  final bool isSaving;
  final VoidCallback onPreviewToggle;
  final VoidCallback onSave;
  final VoidCallback onPublish;
  final VoidCallback onBack;

  const BuilderHeaderWidget({
    Key? key,
    required this.currentPage,
    required this.isPreviewMode,
    required this.isSaving,
    required this.onPreviewToggle,
    required this.onSave,
    required this.onPublish,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageTitle = currentPage?['title'] as String? ?? 'Untitled Page';
    final pageStatus = currentPage?['status'] as String? ?? 'draft';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppTheme.primaryText,
                size: 20,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Page info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pageTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(pageStatus).withAlpha(26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pageStatus.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(pageStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last saved: ${_formatLastSaved()}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action buttons
          Row(
            children: [
              // Preview toggle
              TextButton.icon(
                onPressed: onPreviewToggle,
                icon: Icon(
                  isPreviewMode ? Icons.edit : Icons.visibility,
                  size: 18,
                ),
                label: Text(isPreviewMode ? 'Edit' : 'Preview'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.secondaryText,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Save button
              TextButton.icon(
                onPressed: isSaving ? null : onSave,
                icon: isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                        ),
                      )
                    : Icon(
                        Icons.save,
                        size: 18,
                      ),
                label: Text(isSaving ? 'Saving...' : 'Save'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Publish button
              ElevatedButton.icon(
                onPressed: isSaving ? null : onPublish,
                icon: Icon(
                  pageStatus == 'published' ? Icons.update : Icons.publish,
                  size: 18,
                ),
                label: Text(pageStatus == 'published' ? 'Update' : 'Publish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // More options
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'duplicate':
                      // TODO: Implement duplicate
                      break;
                    case 'delete':
                      // TODO: Implement delete
                      break;
                    case 'analytics':
                      // TODO: Navigate to analytics
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 18),
                        SizedBox(width: 8),
                        Text('Duplicate Page'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'analytics',
                    child: Row(
                      children: [
                        Icon(Icons.analytics, size: 18),
                        SizedBox(width: 8),
                        Text('View Analytics'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Page', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _formatLastSaved() {
    final updatedAt = currentPage?['updated_at'] as String?;
    if (updatedAt == null) return 'Never';
    
    try {
      final date = DateTime.parse(updatedAt);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}