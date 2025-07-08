import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomDomainModal extends StatefulWidget {
  final String currentDomain;
  final Function(String) onDomainUpdate;

  const CustomDomainModal({
    Key? key,
    required this.currentDomain,
    required this.onDomainUpdate,
  }) : super(key: key);

  @override
  State<CustomDomainModal> createState() => _CustomDomainModalState();
}

class _CustomDomainModalState extends State<CustomDomainModal> {
  late TextEditingController _domainController;
  bool _isVerifying = false;
  bool _isVerified = false;
  String _verificationStatus = '';

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController(text: widget.currentDomain);
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _verifyDomain() async {
    setState(() {
      _isVerifying = true;
      _verificationStatus = 'Verifying domain...';
    });

    // Simulate domain verification
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isVerifying = false;
      _isVerified = true;
      _verificationStatus = 'Domain verified successfully!';
    });
  }

  void _saveDomain() {
    widget.onDomainUpdate(_domainController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom Domain',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryText,
                  ),
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
            SizedBox(height: 2.h),
            Text(
              'Connect your own domain to create a professional link in bio page.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            SizedBox(height: 3.h),

            // Domain Input
            Text(
              'Domain Name',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _domainController,
              decoration: InputDecoration(
                hintText: 'yourdomain.com',
                prefixIcon: Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: Text(
                    'https://',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ),
                filled: true,
                fillColor: AppTheme.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.border),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Verification Status
            if (_verificationStatus.isNotEmpty)
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _isVerified
                      ? AppTheme.success.withAlpha(26)
                      : AppTheme.warning.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isVerified ? AppTheme.success : AppTheme.warning,
                  ),
                ),
                child: Row(
                  children: [
                    if (_isVerifying)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.warning),
                        ),
                      )
                    else
                      CustomIconWidget(
                        iconName: _isVerified ? 'check_circle' : 'warning',
                        color:
                            _isVerified ? AppTheme.success : AppTheme.warning,
                        size: 20,
                      ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _verificationStatus,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              _isVerified ? AppTheme.success : AppTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 3.h),

            // DNS Configuration Steps
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DNS Configuration',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryText,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Add these DNS records to your domain provider:',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildDNSRecord('Type', 'Name', 'Value'),
                  Divider(color: AppTheme.border),
                  _buildDNSRecord('CNAME', 'www', 'bio.mewayz.com'),
                  _buildDNSRecord('A', '@', '192.168.1.1'),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // SSL Certificate Status
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.success,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SSL Certificate',
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryText,
                          ),
                        ),
                        Text(
                          'Automatic SSL certificate provisioning',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Enabled',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _domainController.text.isEmpty ? null : _verifyDomain,
                    child:
                        Text(_isVerifying ? 'Verifying...' : 'Verify Domain'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isVerified ? _saveDomain : null,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDNSRecord(String type, String name, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              type,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}