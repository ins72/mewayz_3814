import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/authentication_section_widget.dart';
import './widgets/device_management_widget.dart';
import './widgets/privacy_controls_widget.dart';
import './widgets/security_header_widget.dart';
import './widgets/security_monitoring_widget.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFF1F1F1),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF191919),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.security,
                color: Color(0xFFF1F1F1),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Security Settings',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Security audit action
            },
            icon: const Icon(
              Icons.security_update_good,
              color: Color(0xFFF1F1F1),
              size: 20,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFDFDFD),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SecurityHeaderWidget(),
                  const SizedBox(height: 32),
                  const AuthenticationSectionWidget(),
                  const SizedBox(height: 32),
                  const DeviceManagementWidget(),
                  const SizedBox(height: 32),
                  const PrivacyControlsWidget(),
                  const SizedBox(height: 32),
                  const SecurityMonitoringWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
