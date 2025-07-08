import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyControlsWidget extends StatefulWidget {
  const PrivacyControlsWidget({super.key});

  @override
  State<PrivacyControlsWidget> createState() => _PrivacyControlsWidgetState();
}

class _PrivacyControlsWidgetState extends State<PrivacyControlsWidget> {
  bool _dataEncryptionEnabled = true;
  bool _secureConnectionsEnabled = true;
  bool _dataCollectionEnabled = false;
  bool _analyticsEnabled = true;

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
                    Icons.privacy_tip,
                    color: Color(0xFFF1F1F1),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Privacy Controls',
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
                  _showThirdPartyAppsDialog();
                },
                child: Text(
                  'App Permissions',
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
          _buildPrivacyOption(
            'Data Encryption',
            'Encrypt all data stored in your account',
            _dataEncryptionEnabled,
            (value) {
              setState(() {
                _dataEncryptionEnabled = value;
              });
            },
            Icons.enhanced_encryption,
          ),
          const SizedBox(height: 20),
          _buildPrivacyOption(
            'Secure Connections Only',
            'Only allow secure HTTPS connections',
            _secureConnectionsEnabled,
            (value) {
              setState(() {
                _secureConnectionsEnabled = value;
              });
            },
            Icons.security,
          ),
          const SizedBox(height: 20),
          _buildPrivacyOption(
            'Data Collection',
            'Allow collection of usage data for improvements',
            _dataCollectionEnabled,
            (value) {
              setState(() {
                _dataCollectionEnabled = value;
              });
            },
            Icons.analytics,
          ),
          const SizedBox(height: 20),
          _buildPrivacyOption(
            'Anonymous Analytics',
            'Share anonymous usage statistics',
            _analyticsEnabled,
            (value) {
              setState(() {
                _analyticsEnabled = value;
              });
            },
            Icons.bar_chart,
          ),
          const SizedBox(height: 24),
          _buildDataManagementSection(),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(
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

  Widget _buildDataManagementSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Management',
            style: GoogleFonts.inter(
              color: const Color(0xFFF1F1F1),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildDataManagementItem(
            'Export Data',
            'Download all your account data',
            Icons.download,
            () {
              _showExportDataDialog();
            },
          ),
          const SizedBox(height: 12),
          _buildDataManagementItem(
            'Delete Data',
            'Permanently delete specific data types',
            Icons.delete_outline,
            () {
              _showDeleteDataDialog();
            },
          ),
          const SizedBox(height: 12),
          _buildDataManagementItem(
            'Data Retention',
            'Manage how long data is stored',
            Icons.schedule,
            () {
              _showDataRetentionDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementItem(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
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
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF7B7B7B),
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showThirdPartyAppsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Third-Party App Permissions',
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
              _buildThirdPartyAppItem(
                'Google Analytics',
                'Access to usage data',
                'Connected',
                true,
              ),
              _buildThirdPartyAppItem(
                'Zapier Integration',
                'Automation workflows',
                'Connected',
                true,
              ),
              _buildThirdPartyAppItem(
                'Slack Notifications',
                'Send notifications',
                'Disconnected',
                false,
              ),
            ],
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
              'Done',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartyAppItem(
    String appName,
    String permission,
    String status,
    bool isConnected,
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
              Icons.apps,
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
                  appName,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  permission,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(0xFF4CAF50).withAlpha(26)
                  : const Color(0xFF7B7B7B).withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color: isConnected
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF7B7B7B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Export Data',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Your data export will be sent to your email address. This may take a few minutes to process.',
          style: GoogleFonts.inter(
            color: const Color(0xFF7B7B7B),
            fontSize: 14,
          ),
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
              // Handle data export
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Export',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Delete Data',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Warning: This action cannot be undone. Select the data types you want to delete permanently.',
          style: GoogleFonts.inter(
            color: const Color(0xFFFF5252),
            fontSize: 14,
          ),
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
              // Handle data deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: const Color(0xFFFDFDFD),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showDataRetentionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Data Retention',
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
              'Set how long different types of data should be stored:',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildRetentionOption('Activity Logs', '30 days'),
            _buildRetentionOption('Message History', '1 year'),
            _buildRetentionOption('File Uploads', '2 years'),
            _buildRetentionOption('Analytics Data', '90 days'),
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
              // Handle retention settings
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionOption(String dataType, String period) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dataType,
            style: GoogleFonts.inter(
              color: const Color(0xFFF1F1F1),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1,
              ),
            ),
            child: Text(
              period,
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
