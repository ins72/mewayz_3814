
import '../../../core/app_export.dart';

class ContactCardWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(String) onQuickAction;
  final Color leadScoreColor;
  final Color priorityColor;

  const ContactCardWidget({
    Key? key,
    required this.contact,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onQuickAction,
    required this.leadScoreColor,
    required this.priorityColor,
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
          margin: EdgeInsets.only(bottom: 3.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accent.withAlpha(26)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.accent : AppTheme.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (isMultiSelectMode)
                    Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
                        size: 24,
                      ),
                    ),
                  _buildProfileImage(),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contact['name'] ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildPriorityIndicator(),
                            SizedBox(width: 2.w),
                            _buildLeadScore(),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: AppTheme.secondaryText,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                contact['company'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppTheme.secondaryText,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                contact['email'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Icon(
                        Icons.chevron_right,
                        color: AppTheme.secondaryText,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  _buildStageChip(),
                  SizedBox(width: 3.w),
                  _buildSourceChip(),
                  const Spacer(),
                  Text(
                    'Last activity: ${contact['lastActivity']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
              if (contact['tags'] != null && (contact['tags'] as List).isNotEmpty) ...[
                SizedBox(height: 2.h),
                _buildTagsRow(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Builder(
      builder: (context) => Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.border),
        ),
        child: ClipOval(
          child: contact['profileImage'] != null
              ? CustomImageWidget(
                  imageUrl: contact['profileImage'],
                  width: 14.w,
                  height: 14.w,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: AppTheme.accent.withAlpha(26),
                  child: Center(
                    child: Text(
                      contact['name']?.substring(0, 1).toUpperCase() ?? 'U',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    final priority = contact['priority'] ?? 'low';
    IconData icon;
    switch (priority) {
      case 'high':
        icon = Icons.priority_high;
        break;
      case 'medium':
        icon = Icons.remove;
        break;
      case 'low':
        icon = Icons.low_priority;
        break;
      default:
        icon = Icons.circle;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: priorityColor.withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: priorityColor,
        size: 16,
      ),
    );
  }

  Widget _buildLeadScore() {
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: leadScoreColor.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: leadScoreColor.withAlpha(77)),
        ),
        child: Text(
          '${contact['leadScore']}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: leadScoreColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStageChip() {
    return Builder(
      builder: (context) {
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
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: stageColor.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: stageColor.withAlpha(77)),
          ),
          child: Text(
            contact['stage'] ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: stageColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceChip() {
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSourceIcon(contact['source'] ?? ''),
              color: AppTheme.secondaryText,
              size: 12,
            ),
            SizedBox(width: 1.w),
            Text(
              contact['source'] ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    return Builder(
      builder: (context) {
        final tags = contact['tags'] as List;
        return Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: tags.take(3).map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  IconData _getSourceIcon(String source) {
    switch (source.toLowerCase()) {
      case 'website':
        return Icons.web;
      case 'linkedin':
        return Icons.work;
      case 'referral':
        return Icons.person_add;
      case 'cold email':
        return Icons.email;
      case 'social media':
        return Icons.share;
      default:
        return Icons.source;
    }
  }

  Widget _buildLeftSwipeBackground() {
    return Builder(
      builder: (context) => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.accent.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_forward,
              color: AppTheme.accent,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'Move Stage',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.success.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickActionButton('call', Icons.phone, AppTheme.accent),
          SizedBox(width: 2.w),
          _buildQuickActionButton('email', Icons.email, AppTheme.success),
          SizedBox(width: 2.w),
          _buildQuickActionButton('message', Icons.message, AppTheme.warning),
          SizedBox(width: 2.w),
          _buildQuickActionButton('meeting', Icons.event, AppTheme.error),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String action, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => onQuickAction(action),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryAction,
          size: 20,
        ),
      ),
    );
  }
}