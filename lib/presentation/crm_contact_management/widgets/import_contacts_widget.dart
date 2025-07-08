import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ImportContactsWidget extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onImport;

  const ImportContactsWidget({
    Key? key,
    required this.onImport,
  }) : super(key: key);

  @override
  State<ImportContactsWidget> createState() => _ImportContactsWidgetState();
}

class _ImportContactsWidgetState extends State<ImportContactsWidget> {
  String _selectedImportType = 'csv';
  bool _isImporting = false;

  final List<Map<String, String>> _fieldMappings = [
    {'csv': 'Name', 'system': 'name'},
    {'csv': 'Email', 'system': 'email'},
    {'csv': 'Phone', 'system': 'phone'},
    {'csv': 'Company', 'system': 'company'},
    {'csv': 'Stage', 'system': 'stage'},
    {'csv': 'Source', 'system': 'source'},
  ];

  final List<String> _importTypes = [
    'csv',
    'excel',
    'google_contacts',
    'outlook'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImportTypeSelection(),
                  SizedBox(height: 3.h),
                  _buildFileUploadSection(),
                  SizedBox(height: 3.h),
                  _buildFieldMappingSection(),
                  SizedBox(height: 3.h),
                  _buildImportOptionsSection(),
                  SizedBox(height: 4.h),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.secondaryText,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Import Contacts',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showImportHelp,
            child: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.accent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Source',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _importTypes.map((type) {
            final isSelected = _selectedImportType == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedImportType = type),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accent.withValues(alpha: 0.2)
                      : AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getImportTypeIcon(type),
                      color:
                          isSelected ? AppTheme.accent : AppTheme.secondaryText,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getImportTypeLabel(type),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected ? AppTheme.accent : AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload File',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: _selectFile,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.accent,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Click to upload or drag and drop',
                  style: AppTheme.darkTheme.textTheme.titleSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Supports CSV, Excel, and vCard files',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldMappingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Field Mapping',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Map your file columns to contact fields',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        SizedBox(height: 2.h),
        ..._fieldMappings.map((mapping) => _buildMappingRow(mapping)).toList(),
      ],
    );
  }

  Widget _buildMappingRow(Map<String, String> mapping) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              mapping['csv'] ?? '',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
          CustomIconWidget(
            iconName: 'arrow_forward',
            color: AppTheme.secondaryText,
            size: 20,
          ),
          Expanded(
            flex: 2,
            child: Text(
              _getSystemFieldLabel(mapping['system'] ?? ''),
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Options',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        _buildOptionCheckbox('Skip duplicate contacts', true),
        _buildOptionCheckbox('Auto-assign lead scores', false),
        _buildOptionCheckbox('Send welcome email', false),
        _buildOptionCheckbox('Add to default campaign', false),
      ],
    );
  }

  Widget _buildOptionCheckbox(String label, bool value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (newValue) {
              // Handle checkbox change
            },
          ),
          Expanded(
            child: Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _isImporting ? null : _startImport,
            child: _isImporting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBackground),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text('Importing...'),
                    ],
                  )
                : Text('Import Contacts'),
          ),
        ),
      ],
    );
  }

  String _getImportTypeIcon(String type) {
    switch (type) {
      case 'csv':
        return 'description';
      case 'excel':
        return 'table_chart';
      case 'google_contacts':
        return 'contacts';
      case 'outlook':
        return 'email';
      default:
        return 'file_upload';
    }
  }

  String _getImportTypeLabel(String type) {
    switch (type) {
      case 'csv':
        return 'CSV File';
      case 'excel':
        return 'Excel File';
      case 'google_contacts':
        return 'Google Contacts';
      case 'outlook':
        return 'Outlook';
      default:
        return 'File';
    }
  }

  String _getSystemFieldLabel(String field) {
    switch (field) {
      case 'name':
        return 'Full Name';
      case 'email':
        return 'Email Address';
      case 'phone':
        return 'Phone Number';
      case 'company':
        return 'Company Name';
      case 'stage':
        return 'Pipeline Stage';
      case 'source':
        return 'Lead Source';
      default:
        return field;
    }
  }

  void _selectFile() {
    // Implement file selection logic
  }

  void _startImport() {
    setState(() => _isImporting = true);

    // Simulate import process
    Future.delayed(Duration(seconds: 3), () {
      final mockImportedContacts = [
        {
          "id": "imported_1",
          "name": "John Smith",
          "company": "ABC Corp",
          "email": "john.smith@abccorp.com",
          "phone": "+1 (555) 111-2222",
          "profileImage":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "leadScore": 65,
          "stage": "New",
          "source": "Import",
          "lastActivity": "Just imported",
          "value": "\$10,000",
          "notes": "Imported contact",
          "tags": ["Imported"],
          "activities": [
            {
              "type": "contact_imported",
              "description": "Contact imported from CSV",
              "timestamp": "Just now"
            }
          ]
        },
        {
          "id": "imported_2",
          "name": "Jane Doe",
          "company": "XYZ Solutions",
          "email": "jane.doe@xyzsolutions.com",
          "phone": "+1 (555) 333-4444",
          "profileImage":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "leadScore": 70,
          "stage": "New",
          "source": "Import",
          "lastActivity": "Just imported",
          "value": "\$15,000",
          "notes": "Imported contact",
          "tags": ["Imported"],
          "activities": [
            {
              "type": "contact_imported",
              "description": "Contact imported from CSV",
              "timestamp": "Just now"
            }
          ]
        }
      ];

      widget.onImport(mockImportedContacts);
      Navigator.pop(context);
    });
  }

  void _showImportHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import Help'),
        content: Text(
          'You can import contacts from various sources:\n\n'
          '• CSV/Excel files with contact data\n'
          '• Google Contacts integration\n'
          '• Outlook contacts sync\n'
          '• vCard files\n\n'
          'Make sure your file includes at least name and email columns for successful import.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}