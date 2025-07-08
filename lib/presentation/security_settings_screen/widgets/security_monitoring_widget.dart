import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityMonitoringWidget extends StatefulWidget {
  const SecurityMonitoringWidget({super.key});

  @override
  State<SecurityMonitoringWidget> createState() =>
      _SecurityMonitoringWidgetState();
}

class _SecurityMonitoringWidgetState extends State<SecurityMonitoringWidget> {
  bool _securityAlertsEnabled = true;
  bool _loginAlertsEnabled = true;
  bool _ipWhitelistEnabled = false;

  final List<Map<String, dynamic>> _securityEvents = [
    {
      'type': 'login_success',
      'title': 'Successful Login',
      'description': 'Login from new device: iPhone 15 Pro',
      'timestamp': '2 minutes ago',
      'severity': 'low',
      'icon': Icons.check_circle,
      'color': Color(0xFF4CAF50),
    },
    {
      'type': 'password_change',
      'title': 'Password Changed',
      'description': 'Password was successfully updated',
      'timestamp': '2 days ago',
      'severity': 'medium',
      'icon': Icons.security,
      'color': Color(0xFF2196F3),
    },
    {
      'type': 'failed_login',
      'title': 'Failed Login Attempt',
      'description': 'Multiple failed attempts from IP: 192.168.1.100',
      'timestamp': '3 days ago',
      'severity': 'high',
      'icon': Icons.warning,
      'color': Color(0xFFFF5252),
    },
    {
      'type': 'api_access',
      'title': 'API Access Token Created',
      'description': 'New API token generated for third-party app',
      'timestamp': '1 week ago',
      'severity': 'medium',
      'icon': Icons.key,
      'color': Color(0xFF2196F3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: Color(0xFFF1F1F1),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Security Monitoring',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF1F1F1),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showAdvancedSettingsDialog();
                },
                child: Text(
                  'Advanced',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2196F3),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMonitoringOptions(),
          const SizedBox(height: 24),
          _buildSecurityEventsSection(),
        ],
      ),
    );
  }

  Widget _buildMonitoringOptions() {
    return Column(
      children: [
        _buildMonitoringOption(
          'Security Alerts',
          'Get notified of security events',
          _securityAlertsEnabled,
          (value) {
            setState(() {
              _securityAlertsEnabled = value;
            });
          },
          Icons.notifications_active,
        ),
        const SizedBox(height: 16),
        _buildMonitoringOption(
          'Login Alerts',
          'Alert on new device logins',
          _loginAlertsEnabled,
          (value) {
            setState(() {
              _loginAlertsEnabled = value;
            });
          },
          Icons.login,
        ),
        const SizedBox(height: 16),
        _buildMonitoringOption(
          'IP Whitelist',
          'Only allow access from approved IP addresses',
          _ipWhitelistEnabled,
          (value) {
            setState(() {
              _ipWhitelistEnabled = value;
            });
            if (value) {
              _showIPWhitelistDialog();
            }
          },
          Icons.security,
        ),
      ],
    );
  }

  Widget _buildMonitoringOption(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF101010),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFF1F1F1),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFDFDFD),
          activeTrackColor: const Color(0xFF4CAF50),
          inactiveThumbColor: const Color(0xFF7B7B7B),
          inactiveTrackColor: const Color(0xFF282828),
        ),
      ],
    );
  }

  Widget _buildSecurityEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Security Events',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showAllSecurityEventsDialog();
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  color: const Color(0xFF2196F3),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(
          _securityEvents.take(3).length,
          (index) => _buildSecurityEventCard(_securityEvents[index]),
        ),
      ],
    );
  }

  Widget _buildSecurityEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: event['color'].withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              event['icon'],
              color: event['color'],
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['description'],
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event['timestamp'],
            style: GoogleFonts.inter(
              color: const Color(0xFF7B7B7B),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Advanced Security Settings',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdvancedSettingItem(
              'Session Timeout',
              '15 minutes',
              Icons.timer,
              () {
                // Handle session timeout configuration
              },
            ),
            _buildAdvancedSettingItem(
              'Account Recovery',
              'Configure recovery options',
              Icons.restore,
              () {
                // Handle account recovery configuration
              },
            ),
            _buildAdvancedSettingItem(
              'API Token Management',
              'Manage application tokens',
              Icons.key,
              () {
                _showAPITokenManagementDialog();
              },
            ),
            _buildAdvancedSettingItem(
              'Security Audit Log',
              'View detailed security logs',
              Icons.list_alt,
              () {
                // Handle security audit log
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF282828),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFF1F1F1),
              size: 16,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF1F1F1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7B7B7B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF7B7B7B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showIPWhitelistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'IP Whitelist',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add IP addresses that are allowed to access your account:',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              decoration: InputDecoration(
                hintText: 'Enter IP address (e.g., 192.168.1.100)',
                hintStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                filled: true,
                fillColor: const Color(0xFF101010),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF282828)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Whitelist:',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF282828)),
              ),
              child: Text(
                'Your current IP: 192.168.1.50',
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle IP whitelist addition
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Add IP',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showAPITokenManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'API Token Management',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAPITokenItem(
                'Mobile App Token',
                'Full access',
                'Created: 2 days ago',
                true,
              ),
              _buildAPITokenItem(
                'Zapier Integration',
                'Limited access',
                'Created: 1 week ago',
                true,
              ),
              _buildAPITokenItem(
                'Analytics Tool',
                'Read-only access',
                'Created: 2 weeks ago',
                false,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Create new token
            },
            child: Text(
              'Create New Token',
              style: GoogleFonts.inter(color: const Color(0xFF2196F3)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAPITokenItem(
    String name,
    String permissions,
    String created,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.key,
              color:
                  isActive ? const Color(0xFF4CAF50) : const Color(0xFF7B7B7B),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$permissions • $created',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Revoke token
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252).withAlpha(26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF5252),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllSecurityEventsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'All Security Events',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _securityEvents.length,
            itemBuilder: (context, index) {
              return _buildSecurityEventCard(_securityEvents[index]);
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
