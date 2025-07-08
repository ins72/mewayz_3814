import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AuditTrailWidget extends StatelessWidget {
  const AuditTrailWidget({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> _auditLogs = [
{ 'action': 'Permission Updated',
'details': 'Editor role: Course Creation permission enabled',
'user': 'John Doe',
'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
'type': 'permission_change',
},
{ 'action': 'Role Created',
'details': 'New custom role "Content Manager" created',
'user': 'Jane Smith',
'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
'type': 'role_creation',
},
{ 'action': 'Permission Updated',
'details': 'Viewer role: Analytics Viewing permission disabled',
'user': 'Admin',
'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
'type': 'permission_change',
},
{ 'action': 'Role Assignment',
'details': 'User "mike@example.com" assigned Editor role',
'user': 'Jane Smith',
'timestamp': DateTime.now().subtract(const Duration(days: 1)),
'type': 'role_assignment',
},
{ 'action': 'Permission Updated',
'details': 'Admin role: Billing Access permission enabled',
'user': 'John Doe',
'timestamp': DateTime.now().subtract(const Duration(days: 2)),
'type': 'permission_change',
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
                Icons.history,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Audit Trail',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Show full audit log
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Audit Log Items
          ..._auditLogs.take(5).map((log) => _buildAuditLogItem(log)).toList(),
        ],
      ),
    );
  }

  Widget _buildAuditLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActionColor(log['type']).withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getActionIcon(log['type']),
              size: 16,
              color: _getActionColor(log['type']),
            ),
          ),
          const SizedBox(width: 12),

          // Action Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['action'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log['details'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      log['user'],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(log['timestamp']),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'permission_change':
        return Icons.security;
      case 'role_creation':
        return Icons.add_circle_outline;
      case 'role_assignment':
        return Icons.person_add;
      default:
        return Icons.info_outline;
    }
  }

  Color _getActionColor(String type) {
    switch (type) {
      case 'permission_change':
        return AppTheme.accent;
      case 'role_creation':
        return AppTheme.success;
      case 'role_assignment':
        return AppTheme.warning;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}