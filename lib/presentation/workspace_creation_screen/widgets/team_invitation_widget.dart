import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TeamInvitationWidget extends StatelessWidget {
  final List<Map<String, String>> teamMembers;
  final TextEditingController emailController;
  final String selectedRole;
  final Function(String) onRoleChanged;
  final VoidCallback onAddMember;
  final Function(int) onRemoveMember;

  const TeamInvitationWidget({
    Key? key,
    required this.teamMembers,
    required this.emailController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onAddMember,
    required this.onRemoveMember,
  }) : super(key: key);

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppTheme.accent;
      case 'editor':
        return AppTheme.warning;
      case 'viewer':
        return AppTheme.secondaryText;
      default:
        return AppTheme.secondaryText;
    }
  }

  void _showBulkImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Bulk Import',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import team members from a CSV file with the following format:',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'email,role\njohn@example.com,admin\njane@example.com,editor',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Supported roles: admin, editor, viewer',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle CSV import
            },
            child: const Text('Import CSV'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invite your team',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Add team members to collaborate on your workspace.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 4.h),

          // Add Member Form
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Team Member',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),

                // Email Input
                TextField(
                  controller: emailController,
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    prefixIcon: const CustomIconWidget(
                      iconName: 'mail',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppTheme.primaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppTheme.accent, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 2.h),

                // Role Selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role',
                            style: AppTheme.darkTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: DropdownButton<String>(
                              value: selectedRole,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  onRoleChanged(newValue);
                                }
                              },
                              items: const [
                                DropdownMenuItem(
                                    value: 'admin', child: Text('Admin')),
                                DropdownMenuItem(
                                    value: 'editor', child: Text('Editor')),
                                DropdownMenuItem(
                                    value: 'viewer', child: Text('Viewer')),
                              ],
                              isExpanded: true,
                              underline: Container(),
                              dropdownColor: AppTheme.surface,
                              icon: const CustomIconWidget(
                                iconName: 'keyboard_arrow_down',
                                color: AppTheme.secondaryText,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    ElevatedButton(
                      onPressed:
                          emailController.text.isNotEmpty ? onAddMember : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: AppTheme.primaryAction,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Bulk Import Button
          OutlinedButton.icon(
            onPressed: () => _showBulkImportDialog(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              side: const BorderSide(color: AppTheme.border),
            ),
            icon: const CustomIconWidget(
              iconName: 'file_upload',
              color: AppTheme.primaryText,
              size: 20,
            ),
            label: const Text('Bulk Import from CSV'),
          ),

          SizedBox(height: 3.h),

          // Team Members List
          if (teamMembers.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Team Members (${teamMembers.length})',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    // Clear all members
                    for (int i = teamMembers.length - 1; i >= 0; i--) {
                      onRemoveMember(i);
                    }
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: AppTheme.error),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.accent.withAlpha(51),
                        radius: 2.5.h,
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.accent,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['email'] ?? '',
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getRoleColor(member['role'] ?? '')
                                    .withAlpha(51),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (member['role'] ?? '').toUpperCase(),
                                style: AppTheme.darkTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getRoleColor(member['role'] ?? ''),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemoveMember(index),
                        icon: const CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.error,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'group_add',
                    color: AppTheme.secondaryText,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No team members added yet',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Add team members to collaborate on your workspace',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}