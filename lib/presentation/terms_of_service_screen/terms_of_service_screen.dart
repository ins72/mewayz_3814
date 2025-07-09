
import '../../core/app_export.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
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
          'Terms of Service',
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
                    'Mewayz Terms of Service',
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
                      '1. Acceptance of Terms',
                      'By accessing and using Mewayz, you accept and agree to be bound by the terms and provision of this agreement. These Terms of Service govern your use of the Mewayz platform, including all content, services, and products available at or through the application.',
                    ),
                    
                    _buildSection(
                      '2. Description of Service',
                      'Mewayz is a comprehensive social media management platform that provides tools for content creation, scheduling, analytics, lead generation, and business growth. Our services include but are not limited to:\n\n• Social media content management and scheduling\n• Analytics and performance tracking\n• Lead generation and CRM tools\n• Content templates and creation assistance\n• Team collaboration features\n• Automation and workflow management',
                    ),
                    
                    _buildSection(
                      '3. User Accounts',
                      'To access certain features of Mewayz, you must create an account. You agree to:\n\n• Provide accurate and complete information\n• Maintain the security of your account credentials\n• Accept responsibility for all activities under your account\n• Notify us immediately of any unauthorized use\n• Use the service only for lawful purposes',
                    ),
                    
                    _buildSection(
                      '4. Acceptable Use',
                      'You agree not to use Mewayz for any unlawful or prohibited activities, including:\n\n• Violating any applicable laws or regulations\n• Infringing on intellectual property rights\n• Distributing malware or harmful content\n• Engaging in harassment or abusive behavior\n• Attempting to gain unauthorized access to systems\n• Spamming or sending unsolicited communications',
                    ),
                    
                    _buildSection(
                      '5. Content and Intellectual Property',
                      'You retain ownership of content you create and share through Mewayz. By using our service, you grant us a limited license to use, store, and display your content as necessary to provide the service. You represent that you have the right to share all content you upload to the platform.',
                    ),
                    
                    _buildSection(
                      '6. Privacy and Data Protection',
                      'Your privacy is important to us. Our collection and use of personal information is governed by our Privacy Policy, which is incorporated into these Terms of Service by reference. We implement industry-standard security measures to protect your data.',
                    ),
                    
                    _buildSection(
                      '7. Subscription and Billing',
                      'Mewayz offers both free and paid subscription tiers. For paid subscriptions:\n\n• Billing occurs on a recurring basis\n• You may cancel your subscription at any time\n• Refunds are handled according to our refund policy\n• Subscription fees are non-refundable except as required by law\n• We reserve the right to change pricing with notice',
                    ),
                    
                    _buildSection(
                      '8. Limitation of Liability',
                      'Mewayz is provided "as is" without warranties of any kind. We shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or inability to use the service. This includes but is not limited to damages for loss of profits, data, or business interruption.',
                    ),
                    
                    _buildSection(
                      '9. Termination',
                      'We may terminate or suspend your account and access to the service at our sole discretion, without notice, for conduct that we believe violates these Terms of Service or is harmful to other users, us, or third parties. Upon termination, your right to use the service will cease immediately.',
                    ),
                    
                    _buildSection(
                      '10. Changes to Terms',
                      'We reserve the right to modify these Terms of Service at any time. We will notify users of material changes via email or through the application. Your continued use of the service after changes constitutes acceptance of the new terms.',
                    ),
                    
                    _buildSection(
                      '11. Governing Law',
                      'These Terms of Service shall be governed by and construed in accordance with the laws of the jurisdiction in which Mewayz operates, without regard to conflict of law principles.',
                    ),
                    
                    _buildSection(
                      '12. Contact Information',
                      'If you have any questions about these Terms of Service, please contact us at:\n\nEmail: support@mewayz.com\nWebsite: https://mewayz.com\nAddress: [Your Business Address]',
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
                            'You have read the complete terms',
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
                        'I Accept Terms of Service',
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