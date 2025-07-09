import '../../../core/app_export.dart';

class BackupCodesWidget extends StatefulWidget {
  const BackupCodesWidget({Key? key}) : super(key: key);

  @override
  State<BackupCodesWidget> createState() => _BackupCodesWidgetState();
}

class _BackupCodesWidgetState extends State<BackupCodesWidget> {
  final List<String> backupCodes = [
    '1a2b3c4d',
    '5e6f7g8h',
    '9i0j1k2l',
    '3m4n5o6p',
    '7q8r9s0t',
    '1u2v3w4x',
    '5y6z7a8b',
    '9c0d1e2f',
    '3g4h5i6j',
    '7k8l9m0n',
  ];

  void _copyAllCodes() {
    String allCodes = backupCodes.join('\n');
    Clipboard.setData(ClipboardData(text: allCodes));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Backup codes copied to clipboard'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _downloadCodes() {
    // In a real app, this would download the codes as a file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Backup codes downloaded'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _printCodes() {
    // In a real app, this would print the codes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Backup codes sent to printer'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Backup Codes',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Warning Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.warning.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: AppTheme.warning,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.warning,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Store these codes in a safe place. Each code can only be used once.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Backup Codes List
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recovery Codes',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: backupCodes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  backupCodes[index],
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _copyAllCodes,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.primaryText,
                    side: const BorderSide(
                      color: AppTheme.border,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: AppTheme.primaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Copy',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _downloadCodes,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.primaryText,
                    side: const BorderSide(
                      color: AppTheme.border,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download,
                        size: 16,
                        color: AppTheme.primaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Download',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _printCodes,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.primaryText,
                    side: const BorderSide(
                      color: AppTheme.border,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.print,
                        size: 16,
                        color: AppTheme.primaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Print',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Instructions
          Text(
            'Use these codes to access your account if you lose your phone or can\'t receive verification codes. Each code can only be used once.',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}