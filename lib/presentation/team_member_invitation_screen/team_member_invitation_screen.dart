import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/bulk_invitation_widget.dart';
import './widgets/custom_message_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/invitation_preview_widget.dart';
import './widgets/pending_invitations_widget.dart';
import './widgets/role_selector_widget.dart';

class TeamMemberInvitationScreen extends StatefulWidget {
  const TeamMemberInvitationScreen({Key? key}) : super(key: key);

  @override
  State<TeamMemberInvitationScreen> createState() =>
      _TeamMemberInvitationScreenState();
}

class _TeamMemberInvitationScreenState
    extends State<TeamMemberInvitationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedRole = 'Editor';
  bool _isLoading = false;
  final List<Map<String, dynamic>> _pendingInvitations = [];

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendInvitations() async {
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter at least one email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.error,
        textColor: AppTheme.primaryText,
        fontSize: 14.0,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final emails = _emailController.text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (final email in emails) {
        _pendingInvitations.add({
          'email': email,
          'role': _selectedRole,
          'sentDate': DateTime.now(),
          'status': 'pending',
        });
      }

      _emailController.clear();
      _messageController.clear();

      Fluttertoast.showToast(
        msg: 'Invitations sent successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.success,
        textColor: AppTheme.primaryText,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to send invitations',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.error,
        textColor: AppTheme.primaryText,
        fontSize: 14.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        title: Text(
          'Team Member Invitation',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendInvitations,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryAction,
                foregroundColor: AppTheme.primaryBackground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBackground,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Send Invitations',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBackground,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Input Section
            EmailInputWidget(
              controller: _emailController,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Role Selection Section
            RoleSelectorWidget(
              selectedRole: _selectedRole,
              onRoleChanged: (role) => setState(() => _selectedRole = role),
            ),
            const SizedBox(height: 24),

            // Custom Message Section
            CustomMessageWidget(
              controller: _messageController,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Bulk Invitation Section
            BulkInvitationWidget(
              onBulkInvite: (emails) {
                setState(() {
                  _emailController.text = emails.join('\n');
                });
              },
            ),
            const SizedBox(height: 24),

            // Invitation Preview Section
            if (_emailController.text.isNotEmpty) ...[
              InvitationPreviewWidget(
                emails: _emailController.text
                    .split(RegExp(r'[,\n]'))
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                role: _selectedRole,
                customMessage: _messageController.text,
              ),
              const SizedBox(height: 24),
            ],

            // Pending Invitations Section
            if (_pendingInvitations.isNotEmpty) ...[
              PendingInvitationsWidget(
                invitations: _pendingInvitations,
                onResend: (invitation) {
                  Fluttertoast.showToast(
                    msg: 'Invitation resent to ${invitation['email']}',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: AppTheme.success,
                    textColor: AppTheme.primaryText,
                    fontSize: 14.0,
                  );
                },
                onRevoke: (invitation) {
                  setState(() {
                    _pendingInvitations.remove(invitation);
                  });
                  Fluttertoast.showToast(
                    msg: 'Invitation revoked for ${invitation['email']}',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: AppTheme.warning,
                    textColor: AppTheme.primaryText,
                    fontSize: 14.0,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}