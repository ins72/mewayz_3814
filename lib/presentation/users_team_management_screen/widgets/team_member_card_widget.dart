
import '../../../core/app_export.dart';

class TeamMemberCardWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(String) onRoleChange;
  final VoidCallback onSuspend;
  final VoidCallback onRemove;
  final VoidCallback onSendMessage;
  final VoidCallback onResetPassword;
  final VoidCallback onViewActivity;

  const TeamMemberCardWidget({
    Key? key,
    required this.member,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onRoleChange,
    required this.onSuspend,
    required this.onRemove,
    required this.onSendMessage,
    required this.onResetPassword,
    required this.onViewActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accent.withValues(alpha: 0.1)
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: AppTheme.accent, width: 2)
                    : Border.all(
                        color: AppTheme.border.withValues(alpha: 0.3))),
            child: Stack(children: [
              Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(children: [
                    Row(children: [
                      // Profile Image with Status Indicator
                      Stack(children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CustomImageWidget(
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                imageUrl: member['imageUrl'])),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: member['isOnline']
                                        ? AppTheme.success
                                        : AppTheme.secondaryText,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppTheme.surface, width: 2)))),
                      ]),
                      SizedBox(width: 3.w),

                      // Member Info
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(children: [
                              Expanded(
                                  child: Text(member['name'],
                                      style: AppTheme
                                          .darkTheme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis)),
                              _buildStatusChip(member['status']),
                            ]),
                            SizedBox(height: 0.5.h),
                            Text(member['email'],
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.secondaryText),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 0.5.h),
                            Row(children: [
                              _buildRoleChip(member['role']),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                  iconName: 'access_time',
                                  color: AppTheme.secondaryText,
                                  size: 12),
                              SizedBox(width: 1.w),
                              Text(member['lastLogin'],
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.secondaryText)),
                            ]),
                          ])),

                      // Actions
                      if (!isMultiSelectMode)
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: onSendMessage,
                              icon: CustomIconWidget(
                                  iconName: 'message',
                                  color: AppTheme.secondaryText,
                                  size: 20)),
                          PopupMenuButton<String>(
                              color: AppTheme.surface,
                              onSelected: (value) {
                                switch (value) {
                                  case 'role':
                                    _showRoleChangeDialog(context);
                                    break;
                                  case 'suspend':
                                    onSuspend();
                                    break;
                                  case 'remove':
                                    _showRemoveConfirmation(context);
                                    break;
                                  case 'reset':
                                    onResetPassword();
                                    break;
                                  case 'activity':
                                    onViewActivity();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 'role',
                                        child: Row(children: [
                                          CustomIconWidget(
                                              iconName: 'admin_panel_settings',
                                              color: AppTheme.secondaryText,
                                              size: 20),
                                          SizedBox(width: 2.w),
                                          Text('Change Role'),
                                        ])),
                                    PopupMenuItem(
                                        value: 'reset',
                                        child: Row(children: [
                                          CustomIconWidget(
                                              iconName: 'lock_reset',
                                              color: AppTheme.secondaryText,
                                              size: 20),
                                          SizedBox(width: 2.w),
                                          Text('Reset Password'),
                                        ])),
                                    PopupMenuItem(
                                        value: 'activity',
                                        child: Row(children: [
                                          CustomIconWidget(
                                              iconName: 'timeline',
                                              color: AppTheme.secondaryText,
                                              size: 20),
                                          SizedBox(width: 2.w),
                                          Text('View Activity'),
                                        ])),
                                    PopupMenuItem(
                                        value: 'suspend',
                                        child: Row(children: [
                                          CustomIconWidget(
                                              iconName: 'block',
                                              color: AppTheme.warning,
                                              size: 20),
                                          SizedBox(width: 2.w),
                                          Text('Suspend'),
                                        ])),
                                    PopupMenuItem(
                                        value: 'remove',
                                        child: Row(children: [
                                          CustomIconWidget(
                                              iconName: 'person_remove',
                                              color: AppTheme.error,
                                              size: 20),
                                          SizedBox(width: 2.w),
                                          Text('Remove'),
                                        ])),
                                  ],
                              child: CustomIconWidget(
                                  iconName: 'more_vert',
                                  color: AppTheme.secondaryText,
                                  size: 20)),
                        ]),
                    ]),

                    // Additional Info Row
                    if (!isMultiSelectMode) ...[
                      SizedBox(height: 2.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                                icon: 'devices', text: member['deviceType']),
                            _buildInfoChip(
                                icon: 'location_on',
                                text: member['location'].split(',')[0]),
                            _buildInfoChip(
                                icon: 'trending_up',
                                text: '${member['activityScore']}%'),
                          ]),
                    ],
                  ])),

              // Selection Indicator
              if (isMultiSelectMode)
                Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color:
                                isSelected ? AppTheme.accent : AppTheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.border,
                                width: 2)),
                        child: isSelected
                            ? Icon(Icons.check,
                                color: AppTheme.primaryAction, size: 16)
                            : null)),
            ])));
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = AppTheme.success.withValues(alpha: 0.2);
        textColor = AppTheme.success;
        break;
      case 'inactive':
        backgroundColor = AppTheme.secondaryText.withValues(alpha: 0.2);
        textColor = AppTheme.secondaryText;
        break;
      case 'pending':
        backgroundColor = AppTheme.warning.withValues(alpha: 0.2);
        textColor = AppTheme.warning;
        break;
      default:
        backgroundColor = AppTheme.accent.withValues(alpha: 0.2);
        textColor = AppTheme.accent;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Text(status,
            style: AppTheme.darkTheme.textTheme.bodySmall
                ?.copyWith(color: textColor, fontWeight: FontWeight.w500)));
  }

  Widget _buildRoleChip(String role) {
    Color backgroundColor;
    Color textColor;

    switch (role.toLowerCase()) {
      case 'owner':
        backgroundColor = AppTheme.accent.withValues(alpha: 0.2);
        textColor = AppTheme.accent;
        break;
      case 'admin':
        backgroundColor = AppTheme.success.withValues(alpha: 0.2);
        textColor = AppTheme.success;
        break;
      case 'editor':
        backgroundColor = AppTheme.warning.withValues(alpha: 0.2);
        textColor = AppTheme.warning;
        break;
      case 'viewer':
        backgroundColor = AppTheme.secondaryText.withValues(alpha: 0.2);
        textColor = AppTheme.secondaryText;
        break;
      default:
        backgroundColor = AppTheme.accent.withValues(alpha: 0.2);
        textColor = AppTheme.accent;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Text(role,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 10)));
  }

  Widget _buildInfoChip({required String icon, required String text}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CustomIconWidget(
              iconName: icon, color: AppTheme.secondaryText, size: 14),
          SizedBox(width: 1.w),
          Text(text,
              style: AppTheme.darkTheme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.secondaryText, fontSize: 10)),
        ]));
  }

  void _showRoleChangeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: AppTheme.surface,
            title: Text('Change Role',
                style: AppTheme.darkTheme.textTheme.titleLarge),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              _buildRoleOption(context, 'Owner', 'owner'),
              _buildRoleOption(context, 'Admin', 'admin'),
              _buildRoleOption(context, 'Editor', 'editor'),
              _buildRoleOption(context, 'Viewer', 'viewer'),
            ])));
  }

  Widget _buildRoleOption(BuildContext context, String role, String value) {
    return ListTile(
        title: Text(role, style: AppTheme.darkTheme.textTheme.bodyMedium),
        trailing: member['role'].toLowerCase() == value
            ? CustomIconWidget(
                iconName: 'check', color: AppTheme.accent, size: 20)
            : null,
        onTap: () {
          Navigator.pop(context);
          onRoleChange(role);
        });
  }

  void _showRemoveConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                backgroundColor: AppTheme.surface,
                title: Text('Remove Member',
                    style: AppTheme.darkTheme.textTheme.titleLarge),
                content: Text(
                    'Are you sure you want to remove ${member['name']} from the team? This action cannot be undone.',
                    style: AppTheme.darkTheme.textTheme.bodyMedium),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(color: AppTheme.secondaryText))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onRemove();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          foregroundColor: AppTheme.primaryAction),
                      child: const Text('Remove')),
                ]));
  }
}