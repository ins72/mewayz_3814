import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './file_attachment_widget.dart';

class ContactFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController messageController;
  final String selectedSubject;
  final String selectedPriority;
  final List<String> subjects;
  final List<String> priorities;
  final List<File> attachedFiles;
  final bool isSubmitting;
  final ValueChanged<String> onSubjectChanged;
  final ValueChanged<String> onPriorityChanged;
  final ValueChanged<File> onAddAttachment;
  final ValueChanged<int> onRemoveAttachment;
  final VoidCallback onSubmit;

  const ContactFormWidget({
    super.key,
    required this.formKey,
    required this.messageController,
    required this.selectedSubject,
    required this.selectedPriority,
    required this.subjects,
    required this.priorities,
    required this.attachedFiles,
    required this.isSubmitting,
    required this.onSubjectChanged,
    required this.onPriorityChanged,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit a Support Request',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 20),

            // Subject dropdown
            _buildDropdown(
              'Subject',
              selectedSubject,
              subjects,
              onSubjectChanged,
            ),
            const SizedBox(height: 16),

            // Priority dropdown
            _buildDropdown(
              'Priority',
              selectedPriority,
              priorities,
              onPriorityChanged,
            ),
            const SizedBox(height: 16),

            // Message textarea
            _buildMessageField(),
            const SizedBox(height: 16),

            // File attachments
            FileAttachmentWidget(
              attachedFiles: attachedFiles,
              onAddAttachment: onAddAttachment,
              onRemoveAttachment: onRemoveAttachment,
            ),
            const SizedBox(height: 24),

            // Response time indicator
            _buildResponseTimeIndicator(),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAction,
                  foregroundColor: const Color(0xFF141414),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF141414),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Submitting...',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Submit Request',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.primaryText,
              ),
              dropdownColor: AppTheme.surface,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: messageController,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your message';
            }
            if (value.trim().length < 10) {
              return 'Message must be at least 10 characters long';
            }
            return null;
          },
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryText,
          ),
          decoration: InputDecoration(
            hintText: 'Please describe your issue or question in detail...',
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
            filled: true,
            fillColor: AppTheme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.accent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.error,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${messageController.text.length}/1000',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponseTimeIndicator() {
    String responseTime = _getResponseTime();
    Color priorityColor = _getPriorityColor();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: priorityColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Expected Response Time: $responseTime',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: priorityColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getResponseTime() {
    switch (selectedPriority) {
      case 'Urgent':
        return 'Within 2 hours';
      case 'High':
        return 'Within 4 hours';
      case 'Medium':
        return 'Within 24 hours';
      case 'Low':
        return 'Within 48 hours';
      default:
        return 'Within 24 hours';
    }
  }

  Color _getPriorityColor() {
    switch (selectedPriority) {
      case 'Urgent':
        return AppTheme.error;
      case 'High':
        return AppTheme.warning;
      case 'Medium':
        return AppTheme.accent;
      case 'Low':
        return AppTheme.success;
      default:
        return AppTheme.accent;
    }
  }
}
