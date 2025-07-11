import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../core/app_export.dart';

class FileAttachmentWidget extends StatelessWidget {
  final List<File> attachedFiles;
  final ValueChanged<File> onAddAttachment;
  final ValueChanged<int> onRemoveAttachment;

  const FileAttachmentWidget({
    super.key,
    required this.attachedFiles,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments (Optional)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),

        // Add attachment button
        GestureDetector(
          onTap: () => _showAttachmentOptions(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_file,
                  color: AppTheme.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Attachment',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Attached files list
        if (attachedFiles.isNotEmpty) ...[
          Text(
            'Attached Files:',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          ...attachedFiles.asMap().entries.map((entry) {
            int index = entry.key;
            File file = entry.value;
            return _buildFileItem(file, index);
          }),
        ],

        // File size and type info
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.accent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Max file size: 10MB. Supported formats: PDF, DOC, DOCX, JPG, PNG, TXT',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileItem(File file, int index) {
    String fileName = file.path.split('/').last;
    String fileSize = '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(fileName),
            color: AppTheme.accent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                Text(
                  fileSize,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onRemoveAttachment(index),
            icon: Icon(
              Icons.close,
              color: AppTheme.error,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.attach_file;
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Attachment',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            _buildAttachmentOption(
              context,
              'From Gallery',
              Icons.photo_library,
              () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            _buildAttachmentOption(
              context,
              'From Camera',
              Icons.camera_alt,
              () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            _buildAttachmentOption(
              context,
              'From Files',
              Icons.folder,
              () {
                Navigator.pop(context);
                _pickFileFromStorage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (await _validateFile(file)) {
          onAddAttachment(file);
        }
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image from gallery: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (await _validateFile(file)) {
          onAddAttachment(file);
        }
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image from camera: $e');
    }
  }

  Future<void> _pickFileFromStorage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (await _validateFile(file)) {
          onAddAttachment(file);
        }
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking file from storage: $e');
    }
  }

  Future<bool> _validateFile(File file) async {
    const int maxFileSize = 10 * 1024 * 1024; // 10MB
    final int fileSize = await file.length();

    if (fileSize > maxFileSize) {
      // Show error message
      debugPrint('File size exceeds 10MB limit');
      return false;
    }

    final String extension = file.path.split('.').last.toLowerCase();
    const List<String> allowedExtensions = [
      'pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'
    ];

    if (!allowedExtensions.contains(extension)) {
      // Show error message
      debugPrint('File type not supported');
      return false;
    }

    return true;
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.accent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}