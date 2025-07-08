import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class SecuritySettingsWidget extends StatelessWidget {
  final bool twoFactorEnabled;
  final List<Map<String, dynamic>> activeSessions;
  final Function(bool) onTwoFactorChanged;
  final VoidCallback onChangePassword;
  final Function(int) onLogoutDevice;

  const SecuritySettingsWidget({
    Key? key,
    required this.twoFactorEnabled,
    required this.activeSessions,
    required this.onTwoFactorChanged,
    required this.onChangePassword,
    required this.onLogoutDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Settings',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your account security and authentication methods',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 24),

          // Change Password
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        'Last changed 2 weeks ago',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: onChangePassword,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Change',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Two-Factor Authentication
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  twoFactorEnabled ? Icons.security : Icons.security_outlined,
                  color: twoFactorEnabled
                      ? AppTheme.success
                      : AppTheme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Two-Factor Authentication',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        twoFactorEnabled ? 'Enabled' : 'Disabled',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: twoFactorEnabled
                              ? AppTheme.success
                              : AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: twoFactorEnabled,
                  onChanged: onTwoFactorChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Active Sessions
          Text(
            'Active Sessions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage where you\'re logged in',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 16),

          ...activeSessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Icon(
                    session['device'].toString().contains('iPhone') ||
                            session['device'].toString().contains('Android')
                        ? Icons.phone_iphone
                        : Icons.computer,
                    color: session['current']
                        ? AppTheme.success
                        : AppTheme.secondaryText,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              session['device'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryText,
                              ),
                            ),
                            if (session['current']) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withAlpha(26),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Current',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppTheme.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${session['location']} • ${session['lastActive']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!session['current'])
                    TextButton(
                      onPressed: () => onLogoutDevice(index),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
