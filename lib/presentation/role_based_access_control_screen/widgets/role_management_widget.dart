import '../../../core/app_export.dart';

class RoleManagementWidget extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final VoidCallback onCreateCustomRole;

  const RoleManagementWidget({
    Key? key,
    required this.roles,
    required this.onCreateCustomRole,
  }) : super(key: key);

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
                Icons.group,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Role Management',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onCreateCustomRole,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Custom Role'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...roles.map((role) => _buildRoleCard(role)).toList(),
        ],
      ),
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Role Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getRoleIcon(role['name']),
              color: AppTheme.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Role Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      role['name'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (role['isCustom'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withAlpha(51),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Custom',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.warning,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  role['description'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${role['memberCount']} member${role['memberCount'] == 1 ? '' : 's'}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.secondaryText,
              size: 20,
            ),
            color: AppTheme.surface,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16, color: AppTheme.accent),
                    const SizedBox(width: 8),
                    Text(
                      'Edit Role',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (role['isCustom'])
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: AppTheme.error),
                      const SizedBox(width: 8),
                      Text(
                        'Delete Role',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                // Handle edit role
              } else if (value == 'delete') {
                // Handle delete role
              }
            },
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String roleName) {
    switch (roleName) {
      case 'Owner':
        return Icons.admin_panel_settings;
      case 'Admin':
        return Icons.supervisor_account;
      case 'Editor':
        return Icons.edit;
      case 'Viewer':
        return Icons.visibility;
      default:
        return Icons.person;
    }
  }
}