import 'dart:io';

import '../../core/app_export.dart';
import './widgets/contact_form_widget.dart';
import './widgets/contact_info_widget.dart';
import './widgets/faq_section_widget.dart';
import './widgets/hero_section_widget.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  String _selectedSubject = 'General Inquiry';
  String _selectedPriority = 'Medium';
  List<File> _attachedFiles = [];
  bool _isSubmitting = false;

  final List<String> _subjects = [
    'Technical Issue',
    'Billing Question',
    'Feature Request',
    'General Inquiry',
    'Account Access',
    'Integration Support',
    'Bug Report',
    'Performance Issue'
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];

  void _addAttachment(File file) {
    setState(() {
      _attachedFiles.add(file);
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      _showSuccessDialog();

      // Reset form
      _messageController.clear();
      setState(() {
        _selectedSubject = 'General Inquiry';
        _selectedPriority = 'Medium';
        _attachedFiles.clear();
      });
    } catch (e) {
      // Show error message
      _showErrorDialog();
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppTheme.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Success',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your support request has been submitted successfully!',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ticket Number: #MW-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Expected Response: ${_getResponseTime()}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Error',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
          ],
        ),
        content: Text(
          'Failed to submit your support request. Please try again.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getResponseTime() {
    switch (_selectedPriority) {
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: Column(
        children: [
          // Header
          Container(
            color: AppTheme.primaryBackground,
            padding:
                const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppTheme.primaryText),
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact Us',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero section
                  const HeroSectionWidget(),
                  const SizedBox(height: 24),

                  // Contact form
                  ContactFormWidget(
                    formKey: _formKey,
                    messageController: _messageController,
                    selectedSubject: _selectedSubject,
                    selectedPriority: _selectedPriority,
                    subjects: _subjects,
                    priorities: _priorities,
                    attachedFiles: _attachedFiles,
                    isSubmitting: _isSubmitting,
                    onSubjectChanged: (value) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    },
                    onPriorityChanged: (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                    onAddAttachment: _addAttachment,
                    onRemoveAttachment: _removeAttachment,
                    onSubmit: _submitForm,
                  ),
                  const SizedBox(height: 24),

                  // Contact information
                  const ContactInfoWidget(),
                  const SizedBox(height: 24),

                  // FAQ section
                  const FaqSectionWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}