import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PreviewWidget extends StatefulWidget {
  const PreviewWidget({Key? key}) : super(key: key);

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  String _selectedDevice = 'desktop';
  final TextEditingController _testEmailController = TextEditingController();

  @override
  void dispose() {
    _testEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.preview_outlined,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Preview & Test',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildDeviceSelector(),
        SizedBox(height: 16.h),
        _buildEmailPreview(),
        SizedBox(height: 16.h),
        _buildTestSection(),
      ],
    );
  }

  Widget _buildDeviceSelector() {
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
          Text(
            'Device Preview',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildDeviceButton('desktop', Icons.computer_rounded, 'Desktop'),
              SizedBox(width: 12.w),
              _buildDeviceButton(
                  'mobile', Icons.phone_android_rounded, 'Mobile'),
              SizedBox(width: 12.w),
              _buildDeviceButton('tablet', Icons.tablet_rounded, 'Tablet'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceButton(String device, IconData icon, String label) {
    final isSelected = _selectedDevice == device;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDevice = device;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accent.withAlpha(26)
                : AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.accent : AppTheme.border,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
                size: 24,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailPreview() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: AppTheme.accent,
                  size: 16,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Email Preview - ${_selectedDevice.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.secondaryText,
                    size: 16,
                  ),
                  onPressed: () {
                    // Refresh preview
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'From: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.secondaryText,
                                    ),
                              ),
                              Text(
                                'Company Name <noreply@company.com>',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                'Subject: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.secondaryText,
                                    ),
                              ),
                              Text(
                                'Your Weekly Newsletter',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Email content preview
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello {{first_name}},',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'This is your weekly newsletter with the latest updates and insights from our team.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Read More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Best regards,\nThe Team',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
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
          Text(
            'Send Test Email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _testEmailController,
            decoration: const InputDecoration(
              labelText: 'Test Email Address',
              hintText: 'Enter email address for test',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sendSpamTest,
                  icon: const Icon(Icons.security_outlined),
                  label: const Text('Spam Test'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sendTestEmail,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Send Test'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildPreviewChecklist(),
        ],
      ),
    );
  }

  Widget _buildPreviewChecklist() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pre-flight Checklist',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8.h),
          _buildChecklistItem('Subject line is compelling', true),
          _buildChecklistItem('Email content is complete', true),
          _buildChecklistItem('All links are working', false),
          _buildChecklistItem('Images are optimized', true),
          _buildChecklistItem('Recipient list is selected', true),
          _buildChecklistItem('Spam score is acceptable', false),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String item, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isChecked
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isChecked ? AppTheme.success : AppTheme.secondaryText,
            size: 16,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isChecked
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendTestEmail() {
    if (_testEmailController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test email sent to ${_testEmailController.text}'),
        ),
      );
    }
  }

  void _sendSpamTest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Spam test initiated. Results will be available shortly.'),
      ),
    );
  }
}