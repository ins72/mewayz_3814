import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionMatrixWidget extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final Function(String, String, bool) onPermissionChanged;

  const PermissionMatrixWidget({
    Key? key,
    required this.roles,
    required this.onPermissionChanged,
  }) : super(key: key);

  static final List<Map<String, dynamic>> _permissions = [
    {
      'key': 'dashboard_view',
      'name': 'Dashboard View',
      'description': 'Access to main dashboard and overview',
      'category': 'Core',
      'icon': Icons.dashboard,
    },
    {
      'key': 'social_media_management',
      'name': 'Social Media Management',
      'description': 'Create, schedule, and manage social media posts',
      'category': 'Content',
      'icon': Icons.share,
    },
    {
      'key': 'crm_access',
      'name': 'CRM Access',
      'description': 'Access to customer relationship management',
      'category': 'Core',
      'icon': Icons.contacts,
    },
    {
      'key': 'course_creation',
      'name': 'Course Creation',
      'description': 'Create and manage online courses',
      'category': 'Content',
      'icon': Icons.school,
    },
    {
      'key': 'marketplace_management',
      'name': 'Marketplace Management',
      'description': 'Manage marketplace products and orders',
      'category': 'Commerce',
      'icon': Icons.store,
    },
    {
      'key': 'analytics_viewing',
      'name': 'Analytics Viewing',
      'description': 'View analytics and reports',
      'category': 'Analytics',
      'icon': Icons.analytics,
    },
    {
      'key': 'billing_access',
      'name': 'Billing Access',
      'description': 'Access to billing and payment settings',
      'category': 'Financial',
      'icon': Icons.payment,
    },
    {
      'key': 'user_management',
      'name': 'User Management',
      'description': 'Manage team members and permissions',
      'category': 'Administration',
      'icon': Icons.people,
    },
    {
      'key': 'workspace_settings',
      'name': 'Workspace Settings',
      'description': 'Configure workspace settings and preferences',
      'category': 'Administration',
      'icon': Icons.settings,
    },
    {
      'key': 'delete_workspace',
      'name': 'Delete Workspace',
      'description': 'Permanently delete workspace (critical)',
      'category': 'Administration',
      'icon': Icons.delete_forever,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final categories = _permissions.map((p) => p['category']).toSet().toList();

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
                Icons.security,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Permission Matrix',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Permission Categories
          ...categories
              .map((category) => _buildPermissionCategory(category))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPermissionCategory(String category) {
    final categoryPermissions =
        _permissions.where((p) => p['category'] == category).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 16,
                  color: AppTheme.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Permission Items
          ...categoryPermissions
              .map((permission) => _buildPermissionRow(permission))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(Map<String, dynamic> permission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                permission['icon'],
                size: 18,
                color: AppTheme.secondaryText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      permission['name'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      permission['description'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Role Switches
          Row(
            children: roles
                .map((role) => _buildRoleSwitch(role, permission))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSwitch(
      Map<String, dynamic> role, Map<String, dynamic> permission) {
    final isEnabled = role['permissions'][permission['key']] == true;
    final isOwner = role['name'] == 'Owner';

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isEnabled ? AppTheme.accent : AppTheme.border,
          ),
        ),
        child: Column(
          children: [
            Text(
              role['name'],
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isEnabled ? AppTheme.accent : AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            Switch(
              value: isEnabled,
              onChanged: isOwner
                  ? null
                  : (value) {
                      onPermissionChanged(
                          role['name'], permission['key'], value);
                    },
              activeColor: AppTheme.accent,
              inactiveTrackColor: AppTheme.border,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Core':
        return Icons.dashboard;
      case 'Content':
        return Icons.create;
      case 'Commerce':
        return Icons.store;
      case 'Analytics':
        return Icons.analytics;
      case 'Financial':
        return Icons.payment;
      case 'Administration':
        return Icons.admin_panel_settings;
      default:
        return Icons.category;
    }
  }
}
