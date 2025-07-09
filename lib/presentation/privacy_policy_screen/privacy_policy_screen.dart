
import '../../core/app_export.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 100) {
      if (!_isScrolledToBottom) {
        setState(() {
          _isScrolledToBottom = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: Text(
          'Privacy Policy',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryText,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mewayz Privacy Policy',
                    style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      '1. Introduction',
                      'Welcome to Mewayz. We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our social media management platform.',
                    ),
                    
                    _buildSection(
                      '2. Information We Collect',
                      'We collect several types of information to provide and improve our services:\n\n• Personal Information: Name, email address, phone number, and profile information\n• Usage Data: How you interact with our platform, features used, and time spent\n• Device Information: Device type, operating system, browser type, and IP address\n• Content Data: Posts, images, videos, and other content you create or share\n• Social Media Data: Information from connected social media accounts (with your permission)',
                    ),
                    
                    _buildSection(
                      '3. How We Use Your Information',
                      'We use your information to:\n\n• Provide and maintain our services\n• Improve and personalize your experience\n• Communicate with you about updates and features\n• Analyze usage patterns and platform performance\n• Ensure security and prevent fraud\n• Comply with legal obligations\n• Process payments and manage subscriptions',
                    ),
                    
                    _buildSection(
                      '4. Information Sharing',
                      'We do not sell your personal information. We may share information in the following circumstances:\n\n• With service providers who help us operate our platform\n• When required by law or to protect our rights\n• With your consent for specific purposes\n• In connection with a business transaction (merger, acquisition, etc.)\n• With integrated third-party services you choose to connect',
                    ),
                    
                    _buildSection(
                      '5. Data Security',
                      'We implement appropriate technical and organizational measures to protect your data:\n\n• Encryption of data in transit and at rest\n• Regular security audits and assessments\n• Access controls and authentication requirements\n• Secure data centers and infrastructure\n• Employee training on data protection\n• Incident response procedures',
                    ),
                    
                    _buildSection(
                      '6. Data Retention',
                      'We retain your personal information only as long as necessary to:\n\n• Provide our services to you\n• Comply with legal obligations\n• Resolve disputes and enforce agreements\n• Improve our services and user experience\n\nWhen data is no longer needed, we securely delete or anonymize it.',
                    ),
                    
                    _buildSection(
                      '7. Your Rights',
                      'Depending on your location, you may have the following rights:\n\n• Access: Request information about the data we hold about you\n• Rectification: Request correction of inaccurate data\n• Erasure: Request deletion of your data\n• Portability: Request a copy of your data in a structured format\n• Restriction: Request limitation of processing\n• Objection: Object to certain types of processing\n• Withdraw consent: Withdraw previously given consent',
                    ),
                    
                    _buildSection(
                      '8. Cookies and Tracking',
                      'We use cookies and similar technologies to:\n\n• Remember your preferences and settings\n• Analyze how you use our platform\n• Provide personalized content and features\n• Improve security and prevent fraud\n\nYou can control cookie settings through your browser, but some features may not work properly if cookies are disabled.',
                    ),
                    
                    _buildSection(
                      '9. Third-Party Services',
                      'Our platform may integrate with third-party services (social media platforms, analytics tools, etc.). These services have their own privacy policies and practices. We encourage you to review their privacy policies before connecting these services.',
                    ),
                    
                    _buildSection(
                      '10. International Data Transfers',
                      'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data during international transfers, including:\n\n• Adequacy decisions\n• Standard contractual clauses\n• Binding corporate rules\n• Certification schemes',
                    ),
                    
                    _buildSection(
                      '11. Changes to Privacy Policy',
                      'We may update this Privacy Policy periodically. We will notify you of material changes via email or through our platform. Your continued use of Mewayz after changes constitutes acceptance of the updated policy.',
                    ),
                    
                    _buildSection(
                      '12. Contact Us',
                      'If you have questions about this Privacy Policy or how we handle your data, please contact us:\n\nEmail: privacy@mewayz.com\nWebsite: https://mewayz.com/privacy\nAddress: [Your Business Address]\n\nData Protection Officer: dpo@mewayz.com',
                    ),

                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Container(
              padding: EdgeInsets.all(6.w),
              child: Column(
                children: [
                  if (_isScrolledToBottom)
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: AppTheme.success.withAlpha(77),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.success,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'You have read the complete privacy policy',
                            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (_isScrolledToBottom) SizedBox(height: 4.h),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: AppTheme.primaryAction,
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                      child: Text(
                        'I Accept Privacy Policy',
                        style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryAction,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}