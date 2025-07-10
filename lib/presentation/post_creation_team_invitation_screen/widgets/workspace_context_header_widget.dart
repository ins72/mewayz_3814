
import '../../../core/app_export.dart';

// Workspace goal enum for this widget
enum WorkspaceGoal {
  socialMediaManagement,
  contentCreation,
  teamCollaboration,
  analytics,
  crmManagement,
  marketing,
  ecommerce,
  other,
}

class WorkspaceContextHeaderWidget extends StatelessWidget {
  final String workspaceName;
  final String workspaceDescription;
  final WorkspaceGoal goal;
  final String teamSize;
  final VoidCallback onEditWorkspace;

  const WorkspaceContextHeaderWidget({
    Key? key,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.goal,
    required this.teamSize,
    required this.onEditWorkspace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryAction.withAlpha(26),
            AppTheme.primaryAction.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.primaryAction.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workspace header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAction,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: _getGoalIcon(goal),
                  color: AppTheme.primaryBackground,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workspaceName,
                            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onEditWorkspace,
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.primaryAction,
                            size: 5.w,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _getGoalDisplayName(goal),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryAction,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Workspace description
          Text(
            workspaceDescription,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryText,
              height: 1.4,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Team size indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryAction.withAlpha(51),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'group',
                  color: AppTheme.primaryAction,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Team Size: $teamSize',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryAction,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGoalIcon(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return 'share';
      case WorkspaceGoal.contentCreation:
        return 'create';
      case WorkspaceGoal.teamCollaboration:
        return 'group';
      case WorkspaceGoal.analytics:
        return 'analytics';
      case WorkspaceGoal.crmManagement:
        return 'contact_page';
      case WorkspaceGoal.marketing:
        return 'campaign';
      case WorkspaceGoal.ecommerce:
        return 'shopping_cart';
      case WorkspaceGoal.other:
        return 'business';
    }
  }

  String _getGoalDisplayName(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return 'Social Media Management';
      case WorkspaceGoal.contentCreation:
        return 'Content Creation';
      case WorkspaceGoal.teamCollaboration:
        return 'Team Collaboration';
      case WorkspaceGoal.analytics:
        return 'Analytics & Insights';
      case WorkspaceGoal.crmManagement:
        return 'CRM Management';
      case WorkspaceGoal.marketing:
        return 'Marketing Campaigns';
      case WorkspaceGoal.ecommerce:
        return 'E-commerce';
      case WorkspaceGoal.other:
        return 'Custom Workspace';
    }
  }
}