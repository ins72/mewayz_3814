import '../../../core/app_export.dart';

class RoleSelectorWidget extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;

  const RoleSelectorWidget({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _roles = [
    {
      'name': 'Owner',
      'description':
          'Full access to all features and settings. Can manage billing and delete workspace.',
      'permissions': ['Full Access', 'Billing Management', 'Delete Workspace'],
      'icon': Icons.admin_panel_settings,
    },
    {
      'name': 'Admin',
      'description':
          'Can manage team members, access all features except billing and workspace deletion.',
      'permissions': ['Team Management', 'All Features', 'Settings Access'],
      'icon': Icons.supervisor_account,
    },
    {
      'name': 'Editor',
      'description':
          'Can create, edit, and publish content. Access to most features.',
      'permissions': ['Content Creation', 'Publishing', 'Analytics View'],
      'icon': Icons.edit,
    },
    {
      'name': 'Viewer',
      'description':
          'Read-only access to workspace content and basic analytics.',
      'permissions': ['View Content', 'Basic Analytics', 'Comment Access'],
      'icon': Icons.visibility,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_add,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Role Assignment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._roles.map((role) => _buildRoleCard(role)),
        ],
      ),
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    final isSelected = selectedRole == role['name'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.accent.withAlpha(26)
            : AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppTheme.accent : AppTheme.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onRoleChanged(role['name']),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  role['icon'] as IconData,
                  color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: (role['permissions'] as List<String>)
                            .map((permission) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Text(
                              permission,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: role['name'],
                  groupValue: selectedRole,
                  onChanged: (value) => onRoleChanged(value!),
                  activeColor: AppTheme.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}