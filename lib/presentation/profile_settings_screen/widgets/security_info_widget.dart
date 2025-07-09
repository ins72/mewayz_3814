import '../../../core/app_export.dart';

class SecurityInfoWidget extends StatelessWidget {
  const SecurityInfoWidget({Key? key}) : super(key: key);

  void _showActiveSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Active Sessions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSessionItem(
              'Current Session',
              'iPhone 14 Pro • iOS 16.4',
              'New York, NY • 2 minutes ago',
              true,
            ),
            const SizedBox(height: 12),
            _buildSessionItem(
              'Web Session',
              'Chrome on macOS',
              'New York, NY • 1 hour ago',
              false,
            ),
            const SizedBox(height: 12),
            _buildSessionItem(
              'Web Session',
              'Safari on iPad',
              'New York, NY • 2 days ago',
              false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.accent,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout from all devices
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.primaryText,
            ),
            child: Text(
              'Logout All',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(
    String title,
    String device,
    String location,
    bool isCurrent,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppTheme.accent.withAlpha(26)
            : AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent ? AppTheme.accent : AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.smartphone : Icons.computer,
            color: isCurrent ? AppTheme.accent : AppTheme.secondaryText,
            size: 20,
          ),
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
                Text(
                  device,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                  ),
                ),
                Text(
                  location,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            IconButton(
              onPressed: () {
                // TODO: Implement logout from specific device
              },
              icon: Icon(
                Icons.logout,
                color: AppTheme.error,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Security',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 24),

          // Last Login
          _buildSecurityItem(
            'Last Login',
            'January 15, 2024 at 2:30 PM',
            Icons.login,
            null,
          ),

          const SizedBox(height: 16),

          // Password Last Changed
          _buildSecurityItem(
            'Password Last Changed',
            'December 10, 2023',
            Icons.lock,
            () {
              // TODO: Navigate to change password
            },
          ),

          const SizedBox(height: 16),

          // Two-Factor Authentication
          _buildSecurityItem(
            'Two-Factor Authentication',
            'Enabled',
            Icons.security,
            () {
              // TODO: Navigate to 2FA settings
            },
          ),

          const SizedBox(height: 16),

          // Active Sessions
          _buildSecurityItem(
            'Active Sessions',
            '3 active sessions',
            Icons.devices,
            () => _showActiveSessionsDialog(context),
          ),

          const SizedBox(height: 24),

          // Security Score
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.success),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield,
                  color: AppTheme.success,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Score: Excellent',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.success,
                        ),
                      ),
                      Text(
                        'Your account is well protected',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
    String title,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.secondaryText,
              size: 24,
            ),
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
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryText,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}