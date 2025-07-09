import '../../../core/app_export.dart';

class SecuritySettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const SecuritySettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<SecuritySettingsWidget> createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  bool _twoFactorEnabled = false;
  bool _ssoEnabled = false;
  bool _passwordPolicy = true;
  bool _sessionTimeout = true;
  bool _auditLogging = true;
  bool _ipWhitelist = false;

  String _sessionTimeoutDuration = '30';
  String _passwordMinLength = '8';

  final List<String> _timeoutOptions = ['15', '30', '60', '120', '480'];
  final List<String> _passwordLengthOptions = ['8', '10', '12', '14', '16'];

  final List<SecurityLog> _recentActivity = [
    SecurityLog(
      action: 'User login',
      user: 'john.doe@example.com',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ipAddress: '192.168.1.100',
      status: 'Success',
    ),
    SecurityLog(
      action: 'Password changed',
      user: 'jane.smith@example.com',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ipAddress: '192.168.1.101',
      status: 'Success',
    ),
    SecurityLog(
      action: 'Failed login attempt',
      user: 'unknown@example.com',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ipAddress: '10.0.0.1',
      status: 'Failed',
    ),
    SecurityLog(
      action: 'Admin access granted',
      user: 'admin@example.com',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ipAddress: '192.168.1.102',
      status: 'Success',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthenticationSection(),
          const SizedBox(height: 24),
          _buildAccessControlSection(),
          const SizedBox(height: 24),
          _buildPasswordPolicySection(),
          const SizedBox(height: 24),
          _buildSessionManagementSection(),
          const SizedBox(height: 24),
          _buildAuditingSection(),
          const SizedBox(height: 24),
          _buildRecentActivitySection(),
        ],
      ),
    );
  }

  Widget _buildAuthenticationSection() {
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
          Text(
            'Authentication',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityToggle(
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security to user accounts',
            value: _twoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
              widget.onChanged();
            },
            icon: Icons.security,
          ),
          const Divider(color: AppTheme.border),
          _buildSecurityToggle(
            title: 'Single Sign-On (SSO)',
            subtitle:
                'Allow users to login with their organization credentials',
            value: _ssoEnabled,
            onChanged: (value) {
              setState(() {
                _ssoEnabled = value;
              });
              widget.onChanged();
            },
            icon: Icons.login,
          ),
          if (_ssoEnabled) ...[
            const SizedBox(height: 16),
            _buildSSOConfiguration(),
          ],
        ],
      ),
    );
  }

  Widget _buildAccessControlSection() {
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
          Text(
            'Access Control',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityToggle(
            title: 'IP Address Whitelist',
            subtitle: 'Restrict access to specific IP addresses',
            value: _ipWhitelist,
            onChanged: (value) {
              setState(() {
                _ipWhitelist = value;
              });
              widget.onChanged();
            },
            icon: Icons.location_on,
          ),
          if (_ipWhitelist) ...[
            const SizedBox(height: 16),
            _buildIPWhitelistConfiguration(),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordPolicySection() {
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
          Text(
            'Password Policy',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityToggle(
            title: 'Enforce Password Policy',
            subtitle: 'Require strong passwords for all users',
            value: _passwordPolicy,
            onChanged: (value) {
              setState(() {
                _passwordPolicy = value;
              });
              widget.onChanged();
            },
            icon: Icons.lock,
          ),
          if (_passwordPolicy) ...[
            const SizedBox(height: 16),
            _buildPasswordPolicyConfiguration(),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionManagementSection() {
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
          Text(
            'Session Management',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityToggle(
            title: 'Session Timeout',
            subtitle: 'Automatically log out inactive users',
            value: _sessionTimeout,
            onChanged: (value) {
              setState(() {
                _sessionTimeout = value;
              });
              widget.onChanged();
            },
            icon: Icons.timer,
          ),
          if (_sessionTimeout) ...[
            const SizedBox(height: 16),
            _buildSessionTimeoutConfiguration(),
          ],
        ],
      ),
    );
  }

  Widget _buildAuditingSection() {
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
          Text(
            'Auditing & Monitoring',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityToggle(
            title: 'Audit Logging',
            subtitle: 'Track all security-related events',
            value: _auditLogging,
            onChanged: (value) {
              setState(() {
                _auditLogging = value;
              });
              widget.onChanged();
            },
            icon: Icons.history,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement export audit logs
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAction,
                  foregroundColor: AppTheme.primaryBackground,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Export Audit Logs',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  // TODO: Implement view all logs
                },
                child: Text(
                  'View All Logs',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Security Activity',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: _recentActivity
                .map((log) => _buildActivityLogRow(log))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _buildSSOConfiguration() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SSO Configuration',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Identity Provider URL',
              hintText: 'https://identity.company.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              filled: true,
              fillColor: AppTheme.surface,
            ),
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryText),
            onChanged: (_) => widget.onChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildIPWhitelistConfiguration() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allowed IP Addresses',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'IP Address or Range',
              hintText: '192.168.1.0/24',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              filled: true,
              fillColor: AppTheme.surface,
            ),
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryText),
            onChanged: (_) => widget.onChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPolicyConfiguration() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Minimum Length:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _passwordMinLength,
                    items: _passwordLengthOptions.map((length) {
                      return DropdownMenuItem(
                        value: length,
                        child: Text('$length characters'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _passwordMinLength = value!;
                      });
                      widget.onChanged();
                    },
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                    dropdownColor: AppTheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTimeoutConfiguration() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session Timeout Settings',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Timeout Duration:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sessionTimeoutDuration,
                    items: _timeoutOptions.map((timeout) {
                      return DropdownMenuItem(
                        value: timeout,
                        child: Text('$timeout minutes'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sessionTimeoutDuration = value!;
                      });
                      widget.onChanged();
                    },
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                    dropdownColor: AppTheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogRow(SecurityLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getLogIcon(log.action),
            color: _getLogColor(log.status),
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.action,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${log.user} • ${log.ipAddress}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getLogColor(log.status).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.status,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getLogColor(log.status),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(log.timestamp),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getLogIcon(String action) {
    switch (action.toLowerCase()) {
      case 'user login':
        return Icons.login;
      case 'password changed':
        return Icons.lock;
      case 'failed login attempt':
        return Icons.warning;
      case 'admin access granted':
        return Icons.admin_panel_settings;
      default:
        return Icons.info;
    }
  }

  Color _getLogColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return AppTheme.success;
      case 'failed':
        return AppTheme.error;
      case 'warning':
        return AppTheme.warning;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

class SecurityLog {
  final String action;
  final String user;
  final DateTime timestamp;
  final String ipAddress;
  final String status;

  SecurityLog({
    required this.action,
    required this.user,
    required this.timestamp,
    required this.ipAddress,
    required this.status,
  });
}