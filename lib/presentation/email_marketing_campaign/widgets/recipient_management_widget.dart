import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RecipientManagementWidget extends StatefulWidget {
  const RecipientManagementWidget({Key? key}) : super(key: key);

  @override
  State<RecipientManagementWidget> createState() =>
      _RecipientManagementWidgetState();
}

class _RecipientManagementWidgetState extends State<RecipientManagementWidget> {
  final List<String> _selectedLists = [];
  final TextEditingController _searchController = TextEditingController();
  String _segmentFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
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
              Icons.people_outline_rounded,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Recipient Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildContactListSelection(),
        SizedBox(height: 16.h),
        _buildAdvancedSegmentation(),
        SizedBox(height: 16.h),
        _buildRecipientPreview(),
        SizedBox(height: 16.h),
        _buildBulkImportSection(),
      ],
    );
  }

  Widget _buildContactListSelection() {
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
            'Select Contact Lists',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search contact lists...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            children: [
              _buildContactListItem('All Subscribers', 1247, true),
              _buildContactListItem('Newsletter Subscribers', 823, false),
              _buildContactListItem('Premium Customers', 156, false),
              _buildContactListItem('Trial Users', 298, false),
              _buildContactListItem('Inactive Users', 89, false),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _createNewList,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create List'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _importContacts,
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Import Contacts'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactListItem(String name, int count, bool isSelected) {
    return CheckboxListTile(
      title: Text(name),
      subtitle: Text('$count contacts'),
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedLists.add(name);
          } else {
            _selectedLists.remove(name);
          }
        });
      },
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildAdvancedSegmentation() {
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
              Text(
                'Advanced Segmentation',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _openSegmentBuilder,
                child: const Text('Advanced Filter'),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSegmentChip('All', _segmentFilter == 'All'),
                SizedBox(width: 8.w),
                _buildSegmentChip('Engaged', _segmentFilter == 'Engaged'),
                SizedBox(width: 8.w),
                _buildSegmentChip(
                    'New Subscribers', _segmentFilter == 'New Subscribers'),
                SizedBox(width: 8.w),
                _buildSegmentChip('High Value', _segmentFilter == 'High Value'),
                SizedBox(width: 8.w),
                _buildSegmentChip(
                    'Location Based', _segmentFilter == 'Location Based'),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildSegmentPreview(),
        ],
      ),
    );
  }

  Widget _buildSegmentChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _segmentFilter = selected ? label : 'All';
        });
      },
      selectedColor: AppTheme.accent,
      backgroundColor: AppTheme.primaryBackground,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
      ),
    );
  }

  Widget _buildSegmentPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: AppTheme.accent,
            size: 16,
          ),
          SizedBox(width: 8.w),
          Text(
            'Segment: $_segmentFilter',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryText,
                ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '847 contacts',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientPreview() {
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
              Text(
                'Recipient Preview',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Text(
                '847 recipients',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(
            children: [
              _buildRecipientItem(
                  'john.doe@example.com', 'John Doe', 'Premium Customer'),
              _buildRecipientItem('jane.smith@example.com', 'Jane Smith',
                  'Newsletter Subscriber'),
              _buildRecipientItem(
                  'mike.johnson@example.com', 'Mike Johnson', 'Trial User'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _validateEmails,
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Validate Emails'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _exportRecipients,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export List'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientItem(String email, String name, String segment) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.accent.withAlpha(26),
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              segment,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkImportSection() {
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
            'Bulk Import',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppTheme.border, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: AppTheme.secondaryText,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Drop CSV file here or click to browse',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryText,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Support for CSV files with email, name, and custom fields',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloadTemplate,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download Template'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selectFile,
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Select File'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createNewList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New List'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'List Name',
            hintText: 'Enter list name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle list creation
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _importContacts() {
    // Handle contact import
  }

  void _openSegmentBuilder() {
    // Open advanced segment builder
  }

  void _validateEmails() {
    // Handle email validation
  }

  void _exportRecipients() {
    // Handle recipient export
  }

  void _downloadTemplate() {
    // Handle template download
  }

  void _selectFile() {
    // Handle file selection
  }
}