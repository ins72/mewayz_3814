import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class NotificationPreviewWidget extends StatelessWidget {
  final Map<String, Map<String, bool>> notificationSettings;

  const NotificationPreviewWidget({
    Key? key,
    required this.notificationSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.preview_outlined,
                    color: AppTheme.accent, size: 20)),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Notification Preview',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText)),
                  const SizedBox(height: 4),
                  Text('Test how notifications will look and feel',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppTheme.secondaryText)),
                ])),
          ]),
          const SizedBox(height: 24),

          // Sample Notifications
          _buildSampleNotification(
              'New lead from Instagram',
              'Jane Smith started following your account',
              Icons.person_add,
              AppTheme.success,
              _isNotificationEnabled('crm')),
          const SizedBox(height: 12),
          _buildSampleNotification(
              'Course completion',
              'Mike Johnson completed "Digital Marketing 101"',
              Icons.school,
              AppTheme.accent,
              _isNotificationEnabled('courses')),
          const SizedBox(height: 12),
          _buildSampleNotification(
              'New marketplace order',
              'Order #12345 received for \$299.99',
              Icons.shopping_cart,
              AppTheme.warning,
              _isNotificationEnabled('marketplace')),
          const SizedBox(height: 12),
          _buildSampleNotification(
              'Payment received',
              'Invoice #INV-001 paid successfully',
              Icons.payment,
              AppTheme.success,
              _isNotificationEnabled('financial')),
          const SizedBox(height: 24),

          // Test Notification Button
          Center(
              child: OutlinedButton(
                  onPressed: () {
                    _showTestNotification(context);
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.border),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.notifications_active,
                        color: AppTheme.accent, size: 18),
                    const SizedBox(width: 8),
                    Text('Test Notification',
                        style: GoogleFonts.inter(
                            fontSize: 16, color: AppTheme.primaryText)),
                  ]))),
        ]));
  }

  Widget _buildSampleNotification(String title, String message, IconData icon,
      Color iconColor, bool enabled) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Row(children: [
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: iconColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 16)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: enabled
                            ? AppTheme.primaryText
                            : AppTheme.secondaryText)),
                const SizedBox(height: 2),
                Text(message,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: enabled
                            ? AppTheme.secondaryText
                            : AppTheme.secondaryText.withAlpha(179))),
              ])),
          if (!enabled)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppTheme.secondaryText.withAlpha(26),
                    borderRadius: BorderRadius.circular(4)),
                child: Text('Disabled',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.w500))),
        ]));
  }

  bool _isNotificationEnabled(String category) {
    final settings = notificationSettings[category];
    if (settings == null) return false;
    return settings['push'] == true || settings['inApp'] == true;
  }

  void _showTestNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          Icon(Icons.notifications_active, color: AppTheme.accent, size: 16),
          const SizedBox(width: 8),
          Text('Test notification sent! Check your device notifications.',
              style:
                  GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryText)),
        ]),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
  }
}
