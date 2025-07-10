
import '../../../core/app_export.dart';

// Member role enum for this widget
enum MemberRole {
  owner,
  admin,
  editor,
  contributor,
  viewer,
  socialMediaManager,
  contentCreator,
  analyst,
  designer,
  copywriter,
}

class RoleAssignmentWidget extends StatelessWidget {
  final MemberRole selectedRole;
  final Function(MemberRole) onRoleChanged;
  final bool isEnabled;

  const RoleAssignmentWidget({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign Role',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryText)),
          
          SizedBox(height: 2.h),
          
          Text(
            'Select the appropriate role for the team member',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText)),
          
          SizedBox(height: 3.h),
          
          // Role options
          ...MemberRole.values.map((role) => _buildRoleOption(role)).toList(),
        ]));
  }

  Widget _buildRoleOption(MemberRole role) {
    final isSelected = selectedRole == role;
    
    return GestureDetector(
      onTap: isEnabled ? () => onRoleChanged(role) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryAction.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryAction
                : AppTheme.secondaryText)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryAction
                    : AppTheme.secondaryText,
                borderRadius: BorderRadius.circular(1.5.w)),
              child: CustomIconWidget(
                iconName: _getRoleIcon(role),
                color: isSelected 
                    ? AppTheme.primaryBackground
                    : AppTheme.secondaryText,
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
                      color: isSelected 
                          ? AppTheme.primaryAction
                          : AppTheme.primaryText)),
                  
                  SizedBox(height: 0.5.h),
                  
                  Text(
                    _getRoleDescription(role),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText)),
                ])),
            
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.primaryAction,
                size: 5.w),
          ])));
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