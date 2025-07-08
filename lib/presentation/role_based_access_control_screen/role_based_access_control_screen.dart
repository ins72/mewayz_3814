import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/audit_trail_widget.dart';
import './widgets/custom_role_modal_widget.dart';
import './widgets/permission_matrix_widget.dart';
import './widgets/role_management_widget.dart';

class RoleBasedAccessControlScreen extends StatefulWidget {
  const RoleBasedAccessControlScreen({Key? key}) : super(key: key);

  @override
  State<RoleBasedAccessControlScreen> createState() =>
      _RoleBasedAccessControlScreenState();
}

class _RoleBasedAccessControlScreenState
    extends State<RoleBasedAccessControlScreen> {
  final List<Map<String, dynamic>> _roles = [
    {
      'name': 'Owner',
      'description': 'Full access to all features and settings',
      'memberCount': 1,
      'isCustom': false,
      'permissions': {
        'dashboard_view': true,
        'social_media_management': true,
        'crm_access': true,
        'course_creation': true,
        'marketplace_management': true,
        'analytics_viewing': true,
        'billing_access': true,
        'user_management': true,
        'workspace_settings': true,
        'delete_workspace': true,
      },
    },
    {
      'name': 'Admin',
      'description': 'Can manage team members and access most features',
      'memberCount': 3,
      'isCustom': false,
      'permissions': {
        'dashboard_view': true,
        'social_media_management': true,
        'crm_access': true,
        'course_creation': true,
        'marketplace_management': true,
        'analytics_viewing': true,
        'billing_access': false,
        'user_management': true,
        'workspace_settings': true,
        'delete_workspace': false,
      },
    },
    {
      'name': 'Editor',
      'description': 'Can create, edit, and publish content',
      'memberCount': 5,
      'isCustom': false,
      'permissions': {
        'dashboard_view': true,
        'social_media_management': true,
        'crm_access': true,
        'course_creation': true,
        'marketplace_management': false,
        'analytics_viewing': true,
        'billing_access': false,
        'user_management': false,
        'workspace_settings': false,
        'delete_workspace': false,
      },
    },
    {
      'name': 'Viewer',
      'description': 'Read-only access to workspace content',
      'memberCount': 8,
      'isCustom': false,
      'permissions': {
        'dashboard_view': true,
        'social_media_management': false,
        'crm_access': false,
        'course_creation': false,
        'marketplace_management': false,
        'analytics_viewing': true,
        'billing_access': false,
        'user_management': false,
        'workspace_settings': false,
        'delete_workspace': false,
      },
    },
  ];

  bool _hasUnsavedChanges = false;

  void _updatePermission(String roleName, String permission, bool value) {
    setState(() {
      final role = _roles.firstWhere((r) => r['name'] == roleName);
      role['permissions'][permission] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _saveChanges() async {
    setState(() {
      _hasUnsavedChanges = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    Fluttertoast.showToast(
      msg: 'Role permissions updated successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryText,
      fontSize: 14.0,
    );
  }

  void _showCustomRoleModal() {
    showDialog(
      context: context,
      builder: (context) => CustomRoleModalWidget(
        onRoleCreated: (role) {
          setState(() {
            _roles.add(role);
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        title: Text(
          'Role-Based Access Control',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _hasUnsavedChanges ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasUnsavedChanges
                    ? AppTheme.primaryAction
                    : AppTheme.surface,
                foregroundColor: _hasUnsavedChanges
                    ? AppTheme.primaryBackground
                    : AppTheme.secondaryText,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save Changes',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Management Section
            RoleManagementWidget(
              roles: _roles,
              onCreateCustomRole: _showCustomRoleModal,
            ),
            const SizedBox(height: 24),

            // Permission Matrix Section
            PermissionMatrixWidget(
              roles: _roles,
              onPermissionChanged: _updatePermission,
            ),
            const SizedBox(height: 24),

            // Audit Trail Section
            AuditTrailWidget(),
            const SizedBox(height: 24),

            // Advanced Settings Section
            _buildAdvancedSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
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
                Icons.settings_applications,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Advanced Settings',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Session Timeout',
            'Set automatic logout time for inactive users',
            Icons.timer,
            trailing: DropdownButton<String>(
              value: '30 minutes',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.primaryText,
              ),
              dropdownColor: AppTheme.surface,
              items: ['15 minutes', '30 minutes', '1 hour', '2 hours']
                  .map((time) => DropdownMenuItem(
                        value: time,
                        child: Text(time),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ),
          _buildSettingItem(
            'IP Restrictions',
            'Limit access to specific IP addresses',
            Icons.security,
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: AppTheme.accent,
            ),
          ),
          _buildSettingItem(
            'Two-Factor Authentication',
            'Require 2FA for all admin users',
            Icons.lock,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.accent,
            ),
          ),
          _buildSettingItem(
            'Inheritance Rules',
            'Configure how permissions cascade between roles',
            Icons.account_tree,
            trailing: TextButton(
              onPressed: () {},
              child: Text(
                'Configure',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon,
      {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.secondaryText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
