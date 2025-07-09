
import '../../../core/app_export.dart';

class WorkspaceCardWidget extends StatelessWidget {
  final Map<String, dynamic> workspace;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const WorkspaceCardWidget({
    Key? key,
    required this.workspace,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Owner':
        return AppTheme.success;
      case 'Admin':
        return AppTheme.accent;
      case 'Editor':
        return AppTheme.warning;
      case 'Viewer':
        return AppTheme.secondaryText;
      default:
        return AppTheme.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.accent, width: 2)
              : Border.all(color: AppTheme.border, width: 1),
        ),
        child: Row(
          children: [
            // Workspace Logo
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(workspace['logoUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Workspace Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          workspace['name'],
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (workspace['unreadNotifications'] > 0) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${workspace['unreadNotifications']}',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.primaryAction,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    workspace['description'],
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      // Member Count
                      CustomIconWidget(
                        iconName: 'group',
                        color: AppTheme.secondaryText,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${workspace['memberCount']} members',
                        style: AppTheme.darkTheme.textTheme.labelSmall,
                      ),
                      SizedBox(width: 4.w),

                      // Role Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getRoleColor(workspace['role']).withAlpha(51),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          workspace['role'],
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: _getRoleColor(workspace['role']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Last Activity
                      Text(
                        workspace['lastActivity'],
                        style: AppTheme.darkTheme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Selection Indicator
            if (isSelected) ...[
              SizedBox(width: 2.w),
              const CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.accent,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}