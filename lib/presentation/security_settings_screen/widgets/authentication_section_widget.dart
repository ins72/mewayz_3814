import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationSectionWidget extends StatefulWidget {
  const AuthenticationSectionWidget({super.key});

  @override
  State<AuthenticationSectionWidget> createState() =>
      _AuthenticationSectionWidgetState();
}

class _AuthenticationSectionWidgetState
    extends State<AuthenticationSectionWidget> {
  bool _isTwoFactorEnabled = false;
  bool _isBiometricEnabled = true;
  String _passwordStrength = 'Strong';

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
            children: [
              const Icon(
                Icons.lock_outline,
                color: Color(0xFFF1F1F1),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Authentication',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPasswordSection(),
          const SizedBox(height: 24),
          _buildTwoFactorSection(),
          const SizedBox(height: 24),
          _buildBiometricSection(),
          const SizedBox(height: 24),
          _buildBackupCodesSection(),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last changed 30 days ago',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _passwordStrength,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _showChangePasswordDialog();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF191919),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF282828),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Change',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF1F1F1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTwoFactorSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two-Factor Authentication',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add an extra layer of security to your account',
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
          value: _isTwoFactorEnabled,
          onChanged: (value) {
            setState(() {
              _isTwoFactorEnabled = value;
            });
            if (value) {
              _showTwoFactorSetupDialog();
            }
          },
          activeColor: const Color(0xFFFDFDFD),
          activeTrackColor: const Color(0xFF4CAF50),
          inactiveThumbColor: const Color(0xFF7B7B7B),
          inactiveTrackColor: const Color(0xFF282828),
        ),
      ],
    );
  }

  Widget _buildBiometricSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biometric Authentication',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Use fingerprint or face recognition',
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
          value: _isBiometricEnabled,
          onChanged: (value) {
            setState(() {
              _isBiometricEnabled = value;
            });
          },
          activeColor: const Color(0xFFFDFDFD),
          activeTrackColor: const Color(0xFF4CAF50),
          inactiveThumbColor: const Color(0xFF7B7B7B),
          inactiveTrackColor: const Color(0xFF282828),
        ),
      ],
    );
  }

  Widget _buildBackupCodesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backup Recovery Codes',
                style: GoogleFonts.inter(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Generate codes for account recovery',
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
            _showBackupCodesDialog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1,
              ),
            ),
            child: Text(
              'Generate',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              decoration: InputDecoration(
                labelText: 'Current Password',
                labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                filled: true,
                fillColor: const Color(0xFF101010),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF282828)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                filled: true,
                fillColor: const Color(0xFF101010),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF282828)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                filled: true,
                fillColor: const Color(0xFF101010),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF282828)),
                ),
              ),
              obscureText: true,
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
              // Handle password change
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Change Password',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Setup Two-Factor Authentication',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your preferred 2FA method:',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sms, color: Color(0xFFF1F1F1)),
              title: Text(
                'SMS',
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle SMS setup
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFFF1F1F1)),
              title: Text(
                'Email',
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle email setup
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.phone_android, color: Color(0xFFF1F1F1)),
              title: Text(
                'Authenticator App',
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle authenticator app setup
              },
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
        ],
      ),
    );
  }

  void _showBackupCodesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Backup Recovery Codes',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Save these codes in a secure location. Each code can only be used once.',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF282828)),
              ),
              child: Column(
                children: [
                  'ABC123-DEF456',
                  'GHI789-JKL012',
                  'MNO345-PQR678',
                  'STU901-VWX234',
                  'YZA567-BCD890',
                ]
                    .map((code) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            code,
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFFF1F1F1),
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Copy codes to clipboard
            },
            child: Text(
              'Copy',
              style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
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
}
