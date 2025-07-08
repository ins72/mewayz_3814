import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportBottomSheetWidget extends StatefulWidget {
  final List<Map<String, dynamic>> accounts;

  const ExportBottomSheetWidget({
    Key? key,
    required this.accounts,
  }) : super(key: key);

  @override
  State<ExportBottomSheetWidget> createState() =>
      _ExportBottomSheetWidgetState();
}

class _ExportBottomSheetWidgetState extends State<ExportBottomSheetWidget> {
  String _selectedFormat = 'CSV';
  final List<String> _formats = ['CSV', 'Excel'];

  final Map<String, bool> _selectedFields = {
    'username': true,
    'email': true,
    'bio': true,
    'followerCount': true,
    'followingCount': true,
    'postsCount': true,
    'engagementRate': true,
    'profileImage': false,
    'location': true,
    'accountType': true,
    'isVerified': false,
    'lastPostDate': false,
  };

  final Map<String, String> _fieldLabels = {
    'username': 'Username',
    'email': 'Email Address',
    'bio': 'Bio Description',
    'followerCount': 'Follower Count',
    'followingCount': 'Following Count',
    'postsCount': 'Posts Count',
    'engagementRate': 'Engagement Rate',
    'profileImage': 'Profile Image URL',
    'location': 'Location',
    'accountType': 'Account Type',
    'isVerified': 'Verified Status',
    'lastPostDate': 'Last Post Date',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormatSelection(),
                  SizedBox(height: 3.h),
                  _buildFieldSelection(),
                  SizedBox(height: 3.h),
                  _buildExportSummary(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          Expanded(
            child: Text(
              'Export Data',
              style: AppTheme.darkTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            },
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryText,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: _formats.map((format) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedFormat = format;
                  });
                },
                child: Container(
                  margin:
                      EdgeInsets.only(right: format != _formats.last ? 2.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _selectedFormat == format
                        ? AppTheme.accent.withValues(alpha: 0.2)
                        : AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: _selectedFormat == format
                          ? AppTheme.accent
                          : AppTheme.border,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName:
                            format == 'CSV' ? 'description' : 'table_chart',
                        color: _selectedFormat == format
                            ? AppTheme.accent
                            : AppTheme.primaryText,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        format,
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: _selectedFormat == format
                              ? AppTheme.accent
                              : AppTheme.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFieldSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Fields to Export',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _selectAllFields,
                  child: Text(
                    'Select All',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: _deselectAllFields,
                  child: Text(
                    'Clear All',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...(_selectedFields.keys.map((field) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: CheckboxListTile(
              value: _selectedFields[field],
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedFields[field] = value ?? false;
                });
              },
              title: Text(
                _fieldLabels[field] ?? field,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryBackground,
            ),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildExportSummary() {
    int selectedFieldsCount =
        _selectedFields.values.where((selected) => selected).length;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Summary',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Accounts:',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              Text(
                '${widget.accounts.length}',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Fields:',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              Text(
                '$selectedFieldsCount',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Format:',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              Text(
                _selectedFormat,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    int selectedFieldsCount =
        _selectedFields.values.where((selected) => selected).length;
    bool canExport = selectedFieldsCount > 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: canExport ? _exportData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canExport ? AppTheme.primaryAction : AppTheme.border,
                foregroundColor: canExport
                    ? AppTheme.primaryBackground
                    : AppTheme.secondaryText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'file_download',
                    color: canExport
                        ? AppTheme.primaryBackground
                        : AppTheme.secondaryText,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text('Export ${_selectedFormat}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAllFields() {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFields.updateAll((key, value) => true);
    });
  }

  void _deselectAllFields() {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFields.updateAll((key, value) => false);
    });
  }

  void _exportData() {
    HapticFeedback.mediumImpact();

    // Simulate export process
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Export started! You\'ll receive a download link shortly.',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
