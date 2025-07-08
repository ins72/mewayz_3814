import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddContactWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddContactWidget({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  State<AddContactWidget> createState() => _AddContactWidgetState();
}

class _AddContactWidgetState extends State<AddContactWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedStage = 'New';
  String _selectedSource = 'Manual';
  int _leadScore = 50;
  String _estimatedValue = '';

  final List<String> _stages = [
    'New',
    'Qualified',
    'Demo Scheduled',
    'Proposal',
    'Negotiation',
    'Closed Won',
    'Closed Lost'
  ];

  final List<String> _sources = [
    'Manual',
    'Website',
    'LinkedIn',
    'Referral',
    'Cold Email',
    'Social Media',
    'Event',
    'Advertisement'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    SizedBox(height: 3.h),
                    _buildContactDetailsSection(),
                    SizedBox(height: 3.h),
                    _buildLeadInfoSection(),
                    SizedBox(height: 3.h),
                    _buildNotesSection(),
                    SizedBox(height: 4.h),
                    _buildActionButtons(),
                  ],
                ),
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
                'Add New Contact',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showSmartDetection,
            child: CustomIconWidget(
              iconName: 'auto_fix_high',
              color: AppTheme.accent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _companyController,
          decoration: InputDecoration(
            labelText: 'Company',
            prefixIcon: CustomIconWidget(
              iconName: 'business',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Details',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email *',
            prefixIcon: CustomIconWidget(
              iconName: 'email',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone',
            prefixIcon: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeadInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Information',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                'Stage',
                _selectedStage,
                _stages,
                (value) => setState(() => _selectedStage = value!),
                Icons.flag,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildDropdownField(
                'Source',
                _selectedSource,
                _sources,
                (value) => setState(() => _selectedSource = value!),
                Icons.source,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Estimated Value (\$)',
            prefixIcon: CustomIconWidget(
              iconName: 'attach_money',
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _estimatedValue = value,
        ),
        SizedBox(height: 2.h),
        Text(
          'Lead Score: $_leadScore',
          style: AppTheme.darkTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Slider(
          value: _leadScore.toDouble(),
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: (value) => setState(() => _leadScore = value.toInt()),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    IconData icon,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.secondaryText, size: 20),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: AppTheme.surface,
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Additional notes...',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: CustomIconWidget(
                iconName: 'note',
                color: AppTheme.secondaryText,
                size: 20,
              ),
            ),
          ),
        ),
      ],
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
            onPressed: _saveContact,
            child: Text('Save Contact'),
          ),
        ),
      ],
    );
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final newContact = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'company': _companyController.text,
        'stage': _selectedStage,
        'source': _selectedSource,
        'leadScore': _leadScore,
        'value': _estimatedValue.isNotEmpty ? '\$${_estimatedValue}' : '\$0',
        'notes': _notesController.text,
        'lastActivity': 'Just added',
        'profileImage': null,
        'tags': ['New Contact'],
        'activities': [
          {
            'type': 'contact_created',
            'description': 'Contact created',
            'timestamp': 'Just now'
          }
        ]
      };

      widget.onAdd(newContact);
      Navigator.pop(context);
    }
  }

  void _showSmartDetection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Smart Field Detection'),
        content: Text(
          'This feature uses AI to automatically detect and fill contact information from various sources like business cards, email signatures, and social profiles.',
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
