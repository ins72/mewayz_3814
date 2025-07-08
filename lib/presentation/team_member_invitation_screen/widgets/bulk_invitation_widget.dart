import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BulkInvitationWidget extends StatelessWidget {
  final Function(List<String>) onBulkInvite;

  const BulkInvitationWidget({
    Key? key,
    required this.onBulkInvite,
  }) : super(key: key);

  void _showBulkUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BulkUploadModal(onBulkInvite: onBulkInvite),
    );
  }

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
                Icons.upload_file,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Bulk Invitation',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Upload a CSV file with multiple email addresses for bulk invitations',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showBulkUploadModal(context),
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Upload CSV'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: const BorderSide(color: AppTheme.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _downloadTemplate(),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download Template'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadTemplate() {
    // Simulate template download
    Fluttertoast.showToast(
      msg: 'CSV template downloaded',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryText,
      fontSize: 14.0,
    );
  }
}

class _BulkUploadModal extends StatefulWidget {
  final Function(List<String>) onBulkInvite;

  const _BulkUploadModal({required this.onBulkInvite});

  @override
  State<_BulkUploadModal> createState() => _BulkUploadModalState();
}

class _BulkUploadModalState extends State<_BulkUploadModal> {
  final List<String> _emails = [];
  bool _isProcessing = false;

  void _simulateFileUpload() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate file processing
    await Future.delayed(const Duration(seconds: 2));

    // Simulate extracted emails
    final mockEmails = [
      'user1@example.com',
      'user2@example.com',
      'user3@example.com',
      'user4@example.com',
      'user5@example.com',
    ];

    setState(() {
      _emails.addAll(mockEmails);
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bulk Upload CSV',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppTheme.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_emails.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.border, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: AppTheme.secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Drag and drop your CSV file here',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'or',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _simulateFileUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAction,
                      foregroundColor: AppTheme.primaryBackground,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryBackground,
                            ),
                          )
                        : const Text('Browse Files'),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Extracted Emails (${_emails.length})',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _emails.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 16, color: AppTheme.secondaryText),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _emails[index],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _emails.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.close,
                              size: 16, color: AppTheme.error),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _emails.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryText,
                      side: const BorderSide(color: AppTheme.border),
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _emails.isEmpty
                        ? null
                        : () {
                            widget.onBulkInvite(_emails);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAction,
                      foregroundColor: AppTheme.primaryBackground,
                    ),
                    child: const Text('Import Emails'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
