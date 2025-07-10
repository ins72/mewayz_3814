
import '../../../core/app_export.dart';
import './role_assignment_widget.dart';
import './workspace_context_header_widget.dart';
import 'role_assignment_widget.dart' show MemberRole;
import 'workspace_context_header_widget.dart' show WorkspaceGoal;

// Import the enums from their respective widgets

class GoalBasedRoleSuggestionsWidget extends StatelessWidget {
  final WorkspaceGoal goal;
  final Function(MemberRole) onRoleSelected;

  const GoalBasedRoleSuggestionsWidget({
    Key? key,
    required this.goal,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestedRoles = _getSuggestedRoles(goal);
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.primaryAction,
                size: 5.w),
              SizedBox(width: 2.w),
              Text(
                'Suggested Roles',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryText)),
            ]),
          
          SizedBox(height: 1.h),
          
          Text(
            'Based on your workspace goal: ${_getGoalDisplayName(goal)}',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText)),
          
          SizedBox(height: 3.h),
          
          // Suggested roles
          ...suggestedRoles.map((role) => _buildSuggestionCard(role)).toList(),
        ]));
  }

  Widget _buildSuggestionCard(MemberRole role) {
    return GestureDetector(
      onTap: () => onRoleSelected(role),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryAction.withAlpha(13),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: AppTheme.primaryAction.withAlpha(51))),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryAction,
                borderRadius: BorderRadius.circular(1.5.w)),
              child: CustomIconWidget(
                iconName: _getRoleIcon(role),
                color: AppTheme.primaryBackground,
                size: 4.w)),
            
            SizedBox(width: 3.w),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getRoleDisplayName(role),
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryAction)),
                  
                  SizedBox(height: 0.5.h),
                  
                  Text(
                    _getRoleDescription(role),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText)),
                ])),
            
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.primaryAction,
              size: 4.w),
          ])));
  }

  List<MemberRole> _getSuggestedRoles(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return [
          MemberRole.socialMediaManager,
          MemberRole.contentCreator,
          MemberRole.copywriter,
          MemberRole.analyst,
        ];
      case WorkspaceGoal.contentCreation:
        return [
          MemberRole.contentCreator,
          MemberRole.designer,
          MemberRole.copywriter,
          MemberRole.editor,
        ];
      case WorkspaceGoal.teamCollaboration:
        return [
          MemberRole.admin,
          MemberRole.editor,
          MemberRole.contributor,
        ];
      case WorkspaceGoal.analytics:
        return [
          MemberRole.analyst,
          MemberRole.admin,
          MemberRole.viewer,
        ];
      case WorkspaceGoal.crmManagement:
        return [
          MemberRole.admin,
          MemberRole.editor,
          MemberRole.analyst,
        ];
      case WorkspaceGoal.marketing:
        return [
          MemberRole.socialMediaManager,
          MemberRole.contentCreator,
          MemberRole.copywriter,
          MemberRole.designer,
        ];
      case WorkspaceGoal.ecommerce:
        return [
          MemberRole.admin,
          MemberRole.editor,
          MemberRole.analyst,
        ];
      case WorkspaceGoal.other:
        return [
          MemberRole.admin,
          MemberRole.editor,
          MemberRole.contributor,
        ];
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

  String _getRoleIcon(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'crown';
      case MemberRole.admin:
        return 'admin_panel_settings';
      case MemberRole.editor:
        return 'edit';
      case MemberRole.contributor:
        return 'person_add';
      case MemberRole.viewer:
        return 'visibility';
      case MemberRole.socialMediaManager:
        return 'share';
      case MemberRole.contentCreator:
        return 'create';
      case MemberRole.analyst:
        return 'analytics';
      case MemberRole.designer:
        return 'design_services';
      case MemberRole.copywriter:
        return 'edit_note';
    }
  }

  String _getRoleDisplayName(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.admin:
        return 'Administrator';
      case MemberRole.editor:
        return 'Editor';
      case MemberRole.contributor:
        return 'Contributor';
      case MemberRole.viewer:
        return 'Viewer';
      case MemberRole.socialMediaManager:
        return 'Social Media Manager';
      case MemberRole.contentCreator:
        return 'Content Creator';
      case MemberRole.analyst:
        return 'Analyst';
      case MemberRole.designer:
        return 'Designer';
      case MemberRole.copywriter:
        return 'Copywriter';
    }
  }

  String _getRoleDescription(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Full access to all features and settings';
      case MemberRole.admin:
        return 'Manage team members and workspace settings';
      case MemberRole.editor:
        return 'Create, edit, and publish content';
      case MemberRole.contributor:
        return 'Create and edit content (requires approval)';
      case MemberRole.viewer:
        return 'View-only access to workspace content';
      case MemberRole.socialMediaManager:
        return 'Manage social media accounts and campaigns';
      case MemberRole.contentCreator:
        return 'Create and manage content across platforms';
      case MemberRole.analyst:
        return 'Access analytics and generate reports';
      case MemberRole.designer:
        return 'Create visual content and manage brand assets';
      case MemberRole.copywriter:
        return 'Write and edit marketing copy and content';
    }
  }
}