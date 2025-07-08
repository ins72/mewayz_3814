import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CourseSettingsWidget extends StatefulWidget {
  const CourseSettingsWidget({Key? key}) : super(key: key);

  @override
  State<CourseSettingsWidget> createState() => _CourseSettingsWidgetState();
}

class _CourseSettingsWidgetState extends State<CourseSettingsWidget> {
  bool _isDripEnabled = true;
  bool _isCertificateEnabled = true;
  bool _isPublic = false;
  String _selectedPricing = 'paid';
  final TextEditingController _priceController =
      TextEditingController(text: '99.99');

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Course Settings',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.primaryText,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Pricing'),
                  _buildPricingOptions(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Access Control'),
                  _buildAccessControlOptions(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Content Delivery'),
                  _buildContentDeliveryOptions(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Certificates'),
                  _buildCertificateOptions(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Advanced Settings'),
                  _buildAdvancedSettings(),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Save settings
                          },
                          child: Text('Save Settings'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.darkTheme.textTheme.titleMedium,
    );
  }

  Widget _buildPricingOptions() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        RadioListTile<String>(
          title: Text(
            'Free Course',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Available to all users at no cost',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: 'free',
          groupValue: _selectedPricing,
          onChanged: (value) {
            setState(() {
              _selectedPricing = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text(
            'Paid Course',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'One-time purchase for lifetime access',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: 'paid',
          groupValue: _selectedPricing,
          onChanged: (value) {
            setState(() {
              _selectedPricing = value!;
            });
          },
        ),
        if (_selectedPricing == 'paid') ...[
          SizedBox(height: 2.h),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price (USD)',
              prefixText: '\$',
              hintText: '99.99',
            ),
          ),
        ],
        RadioListTile<String>(
          title: Text(
            'Subscription',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Monthly or yearly subscription model',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: 'subscription',
          groupValue: _selectedPricing,
          onChanged: (value) {
            setState(() {
              _selectedPricing = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAccessControlOptions() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Public Course',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Course appears in public marketplace',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: _isPublic,
          onChanged: (value) {
            setState(() {
              _isPublic = value;
            });
          },
        ),
        ListTile(
          title: Text(
            'Enrollment Limit',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Maximum number of students (0 = unlimited)',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          trailing: SizedBox(
            width: 20.w,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentDeliveryOptions() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Drip Content',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Release lessons on a schedule',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: _isDripEnabled,
          onChanged: (value) {
            setState(() {
              _isDripEnabled = value;
            });
          },
        ),
        if (_isDripEnabled) ...[
          ListTile(
            title: Text(
              'Release Schedule',
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Configure when lessons become available',
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.secondaryText,
              size: 16,
            ),
            onTap: () {
              // Open drip schedule settings
            },
          ),
        ],
        ListTile(
          title: Text(
            'Prerequisites',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Set required courses or skills',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.secondaryText,
            size: 16,
          ),
          onTap: () {
            // Open prerequisites settings
          },
        ),
      ],
    );
  }

  Widget _buildCertificateOptions() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Enable Certificates',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Award certificates upon course completion',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          value: _isCertificateEnabled,
          onChanged: (value) {
            setState(() {
              _isCertificateEnabled = value;
            });
          },
        ),
        if (_isCertificateEnabled) ...[
          ListTile(
            title: Text(
              'Certificate Template',
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Customize certificate design and content',
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.secondaryText,
              size: 16,
            ),
            onTap: () {
              // Open certificate template editor
            },
          ),
          ListTile(
            title: Text(
              'Completion Requirements',
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Set minimum completion percentage (80%)',
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.secondaryText,
              size: 16,
            ),
            onTap: () {
              // Open completion requirements
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        ListTile(
          title: Text(
            'SEO Settings',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Optimize course for search engines',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.secondaryText,
            size: 16,
          ),
          onTap: () {
            // Open SEO settings
          },
        ),
        ListTile(
          title: Text(
            'Analytics Tracking',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Configure tracking and analytics',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.secondaryText,
            size: 16,
          ),
          onTap: () {
            // Open analytics settings
          },
        ),
        ListTile(
          title: Text(
            'Backup & Export',
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Download course content and data',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.secondaryText,
            size: 16,
          ),
          onTap: () {
            // Open backup options
          },
        ),
      ],
    );
  }
}