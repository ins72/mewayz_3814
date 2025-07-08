import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomRoleModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onRoleCreated;

  const CustomRoleModalWidget({
    Key? key,
    required this.onRoleCreated,
  }) : super(key: key);

  @override
  State<CustomRoleModalWidget> createState() => _CustomRoleModalWidgetState();
}

class _CustomRoleModalWidgetState extends State<CustomRoleModalWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Map<String, bool> _permissions = {
    'dashboard_view': false,
    'social_media_management': false,
    'crm_access': false,
    'course_creation': false,
    'marketplace_management': false,
    'analytics_viewing': false,
    'billing_access': false,
    'user_management': false,
    'workspace_settings': false,
    'delete_workspace': false,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createRole() {
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a role name',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.error,
        textColor: AppTheme.primaryText,
        fontSize: 14.0,
      );
      return;
    }

    final role = {
      'name': _nameController.text,
      'description': _descriptionController.text.isEmpty
          ? 'Custom role with specific permissions'
          : _descriptionController.text,
      'memberCount': 0,
      'isCustom': true,
      'permissions': Map<String, bool>.from(_permissions),
    };

    widget.onRoleCreated(role);
    Navigator.pop(context);

    Fluttertoast.showToast(
      msg: 'Custom role created successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryText,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create Custom Role',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.close, color: AppTheme.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Role Name
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryText,
                ),
                decoration: InputDecoration(
                  labelText: 'Role Name',
                  hintText: 'Enter role name (e.g., Content Manager)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppTheme.accent, width: 2),
                  ),
                  fillColor: AppTheme.primaryBackground,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryText,
                ),
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Describe the role\'s responsibilities...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppTheme.accent, width: 2),
                  ),
                  fillColor: AppTheme.primaryBackground,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),

              // Permissions Section
              Text(
                'Permissions',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 12),

              // Permissions List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      _buildPermissionGroup('Core Features', [
                        {
                          'key': 'dashboard_view',
                          'name': 'Dashboard View',
                          'icon': Icons.dashboard
                        },
                        {
                          'key': 'crm_access',
                          'name': 'CRM Access',
                          'icon': Icons.contacts
                        },
                        {
                          'key': 'analytics_viewing',
                          'name': 'Analytics Viewing',
                          'icon': Icons.analytics
                        },
                      ]),
                      _buildPermissionGroup('Content Management', [
                        {
                          'key': 'social_media_management',
                          'name': 'Social Media Management',
                          'icon': Icons.share
                        },
                        {
                          'key': 'course_creation',
                          'name': 'Course Creation',
                          'icon': Icons.school
                        },
                      ]),
                      _buildPermissionGroup('Commerce', [
                        {
                          'key': 'marketplace_management',
                          'name': 'Marketplace Management',
                          'icon': Icons.store
                        },
                      ]),
                      _buildPermissionGroup('Administration', [
                        {
                          'key': 'user_management',
                          'name': 'User Management',
                          'icon': Icons.people
                        },
                        {
                          'key': 'workspace_settings',
                          'name': 'Workspace Settings',
                          'icon': Icons.settings
                        },
                        {
                          'key': 'billing_access',
                          'name': 'Billing Access',
                          'icon': Icons.payment
                        },
                        {
                          'key': 'delete_workspace',
                          'name': 'Delete Workspace',
                          'icon': Icons.delete_forever
                        },
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryText,
                        side: const BorderSide(color: AppTheme.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryAction,
                        foregroundColor: AppTheme.primaryBackground,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Create Role'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionGroup(
      String groupName, List<Map<String, dynamic>> permissions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupName,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(height: 8),
          ...permissions
              .map((permission) => _buildPermissionItem(permission))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(Map<String, dynamic> permission) {
    final isEnabled = _permissions[permission['key']] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            permission['icon'],
            size: 18,
            color: AppTheme.secondaryText,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              permission['name'],
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                _permissions[permission['key']] = value;
              });
            },
            activeColor: AppTheme.accent,
            inactiveTrackColor: AppTheme.border,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}