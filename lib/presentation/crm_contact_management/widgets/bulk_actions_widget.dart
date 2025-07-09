
import '../../../core/app_export.dart';

class BulkActionsWidget extends StatelessWidget {
  final Set<String> selectedContacts;
  final List<Map<String, dynamic>> contacts;
  final Function(String) onAction;

  const BulkActionsWidget({
    Key? key,
    required this.selectedContacts,
    required this.contacts,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildActionsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'checklist',
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Bulk Actions (${selectedContacts.length} selected)',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildActionItem(
            'export',
            'Export Contacts',
            'Export selected contacts to CSV/Excel',
            AppTheme.accent,
            () => onAction('export'),
          ),
          _buildActionItem(
            'label',
            'Assign Tags',
            'Add tags to selected contacts',
            AppTheme.warning,
            () => onAction('assign_tags'),
          ),
          _buildActionItem(
            'flag',
            'Change Stage',
            'Move contacts to different pipeline stage',
            AppTheme.success,
            () => onAction('change_stage'),
          ),
          _buildActionItem(
            'email',
            'Send Email Campaign',
            'Send bulk email to selected contacts',
            AppTheme.accent,
            () => onAction('email_campaign'),
          ),
          _buildActionItem(
            'delete',
            'Delete Contacts',
            'Permanently remove selected contacts',
            AppTheme.error,
            () => onAction('delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}