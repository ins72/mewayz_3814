
import '../../../core/app_export.dart';

class WorkspaceSettingsWidget extends StatelessWidget {
  final String privacyLevel;
  final String defaultPermissions;
  final String billingPlan;
  final Function(String) onPrivacyChanged;
  final Function(String) onPermissionsChanged;
  final Function(String) onBillingChanged;

  const WorkspaceSettingsWidget({
    Key? key,
    required this.privacyLevel,
    required this.defaultPermissions,
    required this.billingPlan,
    required this.onPrivacyChanged,
    required this.onPermissionsChanged,
    required this.onBillingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure your workspace',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Set up privacy, permissions, and billing preferences.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 4.h),

          // Privacy Level
          _buildSettingSection(
            title: 'Privacy Level',
            description: 'Control who can access your workspace',
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'Public',
                  subtitle: 'Anyone can view and request to join',
                  value: 'public',
                  groupValue: privacyLevel,
                  onChanged: onPrivacyChanged,
                  icon: 'public',
                ),
                _buildRadioTile(
                  title: 'Private',
                  subtitle: 'Only invited members can access',
                  value: 'private',
                  groupValue: privacyLevel,
                  onChanged: onPrivacyChanged,
                  icon: 'lock',
                ),
                _buildRadioTile(
                  title: 'Invite Only',
                  subtitle: 'Members must be invited by admins',
                  value: 'invite_only',
                  groupValue: privacyLevel,
                  onChanged: onPrivacyChanged,
                  icon: 'mail',
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Default Member Permissions
          _buildSettingSection(
            title: 'Default Member Permissions',
            description: 'Set default role for new members',
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'Admin',
                  subtitle: 'Full access to all features',
                  value: 'admin',
                  groupValue: defaultPermissions,
                  onChanged: onPermissionsChanged,
                  icon: 'admin_panel_settings',
                ),
                _buildRadioTile(
                  title: 'Editor',
                  subtitle: 'Can create and edit content',
                  value: 'editor',
                  groupValue: defaultPermissions,
                  onChanged: onPermissionsChanged,
                  icon: 'edit',
                ),
                _buildRadioTile(
                  title: 'Viewer',
                  subtitle: 'Read-only access',
                  value: 'viewer',
                  groupValue: defaultPermissions,
                  onChanged: onPermissionsChanged,
                  icon: 'visibility',
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Billing Plan
          _buildSettingSection(
            title: 'Billing Plan',
            description: 'Choose your subscription plan',
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'Free',
                  subtitle: 'Basic features for up to 5 members',
                  value: 'free',
                  groupValue: billingPlan,
                  onChanged: onBillingChanged,
                  icon: 'free_breakfast',
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Free',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildRadioTile(
                  title: 'Pro',
                  subtitle: 'Advanced features for growing teams',
                  value: 'pro',
                  groupValue: billingPlan,
                  onChanged: onBillingChanged,
                  icon: 'star',
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '\$29/month',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildRadioTile(
                  title: 'Enterprise',
                  subtitle: 'Custom solutions for large organizations',
                  value: 'enterprise',
                  groupValue: billingPlan,
                  onChanged: onBillingChanged,
                  icon: 'business',
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Custom',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required Function(String) onChanged,
    required String icon,
    Widget? trailing,
  }) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color:
                          isSelected ? AppTheme.accent : AppTheme.primaryText,
                    ),
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
            if (trailing != null) ...[
              SizedBox(width: 2.w),
              trailing,
            ],
            SizedBox(width: 2.w),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (String? value) {
                if (value != null) {
                  onChanged(value);
                }
              },
              activeColor: AppTheme.accent,
            ),
          ],
        ),
      ),
    );
  }
}