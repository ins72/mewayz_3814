import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomDomainModal extends StatefulWidget {
  const CustomDomainModal({Key? key}) : super(key: key);

  @override
  State<CustomDomainModal> createState() => _CustomDomainModalState();
}

class _CustomDomainModalState extends State<CustomDomainModal> {
  final TextEditingController _domainController = TextEditingController();
  bool _isVerifying = false;
  String _verificationStatus = '';

  final List<Map<String, String>> _dnsInstructions = [
    {
      'type': 'CNAME',
      'name': 'www',
      'value': 'mewayz.bio',
      'description': 'Points your www subdomain to our servers',
    },
    {
      'type': 'A',
      'name': '@',
      'value': '192.168.1.1',
      'description': 'Points your root domain to our servers',
    },
    {
      'type': 'TXT',
      'name': '@',
      'value': 'mewayz-verification=abc123def456',
      'description': 'Verifies domain ownership',
    },
  ];

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  void _verifyDomain() {
    if (_domainController.text.isEmpty) {
      setState(() {
        _verificationStatus = 'Please enter a domain name';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _verificationStatus = '';
    });

    // Simulate verification process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _verificationStatus = 'Domain verified successfully!';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 90.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
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
                    _buildDomainInput(),
                    SizedBox(height: 3.h),
                    _buildDNSInstructions(),
                    SizedBox(height: 3.h),
                    _buildVerificationSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'language',
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            'Custom Domain Setup',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          const Spacer(),
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
    );
  }

  Widget _buildDomainInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Your Domain',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Connect your custom domain to make your Link in Bio page accessible at your own URL.',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _domainController,
          decoration: const InputDecoration(
            hintText: 'example.com',
            prefixText: 'https://',
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildDNSInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DNS Configuration',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Add these DNS records to your domain provider:',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.h),
        ..._dnsInstructions.map((record) => _buildDNSRecord(record)).toList(),
      ],
    );
  }

  Widget _buildDNSRecord(Map<String, String> record) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  record['type']!,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  record['description']!,
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    Text(
                      record['name']!,
                      style: AppTheme.dataTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Value',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    Text(
                      record['value']!,
                      style: AppTheme.dataTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'After adding the DNS records, click verify to check if your domain is properly configured.',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isVerifying ? null : _verifyDomain,
            child: _isVerifying
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
                      const Text('Verifying...'),
                    ],
                  )
                : const Text('Verify Domain'),
          ),
        ),
        if (_verificationStatus.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _verificationStatus.contains('successfully')
                  ? AppTheme.success.withValues(alpha: 0.2)
                  : AppTheme.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _verificationStatus.contains('successfully')
                    ? AppTheme.success
                    : AppTheme.error,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _verificationStatus.contains('successfully')
                      ? 'check_circle'
                      : 'error',
                  color: _verificationStatus.contains('successfully')
                      ? AppTheme.success
                      : AppTheme.error,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _verificationStatus,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: _verificationStatus.contains('successfully')
                          ? AppTheme.success
                          : AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
