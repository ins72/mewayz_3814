import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CampaignBuilderWidget extends StatefulWidget {
  const CampaignBuilderWidget({Key? key}) : super(key: key);

  @override
  State<CampaignBuilderWidget> createState() => _CampaignBuilderWidgetState();
}

class _CampaignBuilderWidgetState extends State<CampaignBuilderWidget> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _preheaderController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _preheaderController.dispose();
    _contentController.dispose();
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
              Icons.edit_outlined,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Email Builder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildEmailEditor(),
        SizedBox(height: 16.h),
        _buildToolbar(),
      ],
    );
  }

  Widget _buildEmailEditor() {
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
            'Email Content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject Line',
              hintText: 'Enter email subject line',
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _preheaderController,
            decoration: const InputDecoration(
              labelText: 'Preheader Text',
              hintText: 'Preview text that appears after subject line',
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _contentController,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Email Body',
              hintText: 'Write your email content here...',
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _insertImage,
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Insert Image'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _insertLink,
                  icon: const Icon(Icons.link_outlined),
                  label: const Text('Insert Link'),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _insertPersonalization,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Personalize'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _insertButton,
                  icon: const Icon(Icons.smart_button_outlined),
                  label: const Text('Insert Button'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
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
            'Design Tools',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              _buildToolButton(
                  'Text', Icons.text_fields_rounded, _addTextBlock),
              _buildToolButton('Image', Icons.image_outlined, _addImageBlock),
              _buildToolButton(
                  'Button', Icons.smart_button_outlined, _addButtonBlock),
              _buildToolButton(
                  'Divider', Icons.horizontal_rule_rounded, _addDividerBlock),
              _buildToolButton('Social', Icons.share_outlined, _addSocialBlock),
              _buildToolButton('Spacer', Icons.height_rounded, _addSpacerBlock),
              _buildToolButton('HTML', Icons.code_rounded, _addHtmlBlock),
              _buildToolButton(
                  'Footer', Icons.copyright_outlined, _addFooterBlock),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insertImage() {
    // Open image picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_outlined),
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                // Handle image upload
              },
            ),
            ListTile(
              leading: const Icon(Icons.link_outlined),
              title: const Text('Image URL'),
              onTap: () {
                Navigator.pop(context);
                // Handle image URL input
              },
            ),
          ],
        ),
      ),
    );
  }

  void _insertLink() {
    // Open link dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Link Text',
                hintText: 'Enter link text',
              ),
            ),
            SizedBox(height: 12.h),
            const TextField(
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'Enter URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle link insertion
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );
  }

  void _insertPersonalization() {
    // Show personalization options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personalization'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('First Name'),
              subtitle: const Text('{{first_name}}'),
              onTap: () {
                Navigator.pop(context);
                _insertToken('{{first_name}}');
              },
            ),
            ListTile(
              title: const Text('Last Name'),
              subtitle: const Text('{{last_name}}'),
              onTap: () {
                Navigator.pop(context);
                _insertToken('{{last_name}}');
              },
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: const Text('{{email}}'),
              onTap: () {
                Navigator.pop(context);
                _insertToken('{{email}}');
              },
            ),
            ListTile(
              title: const Text('Company'),
              subtitle: const Text('{{company}}'),
              onTap: () {
                Navigator.pop(context);
                _insertToken('{{company}}');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _insertButton() {
    // Show button options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Button'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Button Text',
                hintText: 'Enter button text',
              ),
            ),
            SizedBox(height: 12.h),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Button URL',
                hintText: 'Enter button URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle button insertion
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );
  }

  void _insertToken(String token) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final newText = text.replaceRange(selection.start, selection.end, token);
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + token.length,
    );
  }

  void _addTextBlock() {
    _insertToken('\n\n[TEXT BLOCK]\nAdd your text content here.\n\n');
  }

  void _addImageBlock() {
    _insertToken('\n\n[IMAGE BLOCK]\nImage placeholder\n\n');
  }

  void _addButtonBlock() {
    _insertToken('\n\n[BUTTON BLOCK]\nButton Text | URL\n\n');
  }

  void _addDividerBlock() {
    _insertToken('\n\n[DIVIDER]\n---\n\n');
  }

  void _addSocialBlock() {
    _insertToken('\n\n[SOCIAL BLOCK]\nSocial media links\n\n');
  }

  void _addSpacerBlock() {
    _insertToken('\n\n[SPACER]\n\n');
  }

  void _addHtmlBlock() {
    _insertToken('\n\n[HTML BLOCK]\n<p>Custom HTML content</p>\n\n');
  }

  void _addFooterBlock() {
    _insertToken('\n\n[FOOTER]\nCompany Name\nAddress\nUnsubscribe Link\n\n');
  }
}