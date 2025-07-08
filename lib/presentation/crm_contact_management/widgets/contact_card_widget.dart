import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ContactCardWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(String) onQuickAction;
  final Color leadScoreColor;

  const ContactCardWidget({
    Key? key,
    required this.contact,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onQuickAction,
    required this.leadScoreColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact['id']),
      background: _buildLeftSwipeBackground(),
      secondaryBackground: _buildRightSwipeBackground(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Handle pipeline stage movement
        } else {
          // Handle quick actions
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accent.withValues(alpha: 0.1)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.accent : AppTheme.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (isMultiSelectMode)
                Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: CustomIconWidget(
                    iconName:
                        isSelected ? 'check_circle' : 'radio_button_unchecked',
                    color:
                        isSelected ? AppTheme.accent : AppTheme.secondaryText,
                    size: 24,
                  ),
                ),
              _buildProfileImage(),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact['name'] ?? '',
                            style: AppTheme.darkTheme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildLeadScore(),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      contact['company'] ?? '',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        _buildStageChip(),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Last activity: ${contact['lastActivity']}',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    contact['value'] ?? '',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.border),
      ),
      child: ClipOval(
        child: contact['profileImage'] != null
            ? CustomImageWidget(
                imageUrl: contact['profileImage'],
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.accent.withValues(alpha: 0.2),
                child: Center(
                  child: Text(
                    contact['name']?.substring(0, 1).toUpperCase() ?? 'U',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLeadScore() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: leadScoreColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${contact['leadScore']}',
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: leadScoreColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStageChip() {
    Color stageColor;
    switch (contact['stage']) {
      case 'New':
        stageColor = AppTheme.secondaryText;
        break;
      case 'Qualified':
        stageColor = AppTheme.accent;
        break;
      case 'Demo Scheduled':
        stageColor = AppTheme.warning;
        break;
      case 'Proposal':
        stageColor = AppTheme.success;
        break;
      case 'Negotiation':
        stageColor = AppTheme.error;
        break;
      default:
        stageColor = AppTheme.success;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: stageColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stageColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        contact['stage'] ?? '',
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: stageColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLeftSwipeBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 4.w),
      color: AppTheme.accent.withValues(alpha: 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'arrow_forward',
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            'Move Stage',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 4.w),
      color: AppTheme.success.withValues(alpha: 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildQuickActionButton('call', 'phone'),
          SizedBox(width: 2.w),
          _buildQuickActionButton('email', 'email'),
          SizedBox(width: 2.w),
          _buildQuickActionButton('message', 'message'),
          SizedBox(width: 2.w),
          _buildQuickActionButton('meeting', 'event'),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String action, String icon) {
    return GestureDetector(
      onTap: () => onQuickAction(action),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.success,
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.primaryAction,
          size: 20,
        ),
      ),
    );
  }
}