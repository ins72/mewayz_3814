
import '../../../core/app_export.dart';

class TemplateLibraryWidget extends StatefulWidget {
  final Function(Map<String, String>) onTemplateSelected;

  const TemplateLibraryWidget({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<TemplateLibraryWidget> createState() => _TemplateLibraryWidgetState();
}

class _TemplateLibraryWidgetState extends State<TemplateLibraryWidget> {
  final List<Map<String, dynamic>> _templates = [
{ 'name': 'Mewayz Mobile App',
'description': 'Complete documentation for the Mewayz mobile application',
'category': 'Mobile App',
'icon': Icons.phone_android,
'sections': { 'Project Overview': '''# Mewayz - Social Media Management Platform A comprehensive Flutter-based mobile application designed to revolutionize social media management, content creation, and digital marketing for individuals and businesses. ## 🚀 Vision Empower users to streamline their social media presence, create engaging content, and grow their digital footprint through an intuitive, all-in-one platform. ## 🎯 Mission To provide cutting-edge tools for social media scheduling, analytics, content creation, and audience engagement while maintaining simplicity and user-friendly design.''',
'Features': '''## ✨ Key Features ### 🎨 Content Creation & Management - **Multi-Platform Posting**: Schedule and publish content across Instagram, Facebook, Twitter, LinkedIn, and TikTok - **Content Templates**: Pre-designed templates for various social media formats - **Hashtag Research**: AI-powered hashtag suggestions and trend analysis - **Content Calendar**: Visual calendar for content planning and scheduling - **Bulk Upload**: Import and schedule multiple posts at once ### 📊 Analytics & Insights - **Real-time Analytics**: Track engagement, reach, and performance metrics - **Audience Insights**: Understand your followers and their behavior - **Competitor Analysis**: Monitor and analyze competitor performance - **Custom Reports**: Generate detailed analytics reports - **ROI Tracking**: Monitor return on investment for marketing campaigns ### 🛍️ E-commerce Integration - **Link-in-Bio Builder**: Create customizable landing pages - **QR Code Generator**: Generate dynamic QR codes for marketing campaigns - **Marketplace Store**: Built-in e-commerce functionality - **Product Catalog**: Manage and showcase products - **Order Management**: Track and fulfill orders ### 🎓 Learning & Development - **Course Creator**: Build and sell online courses - **Interactive Tutorials**: Step-by-step guides and tutorials - **Certification System**: Issue certificates for course completion - **Progress Tracking**: Monitor student progress and engagement ### 📧 Marketing Automation - **Email Marketing**: Create and send targeted email campaigns - **CRM Integration**: Manage customer relationships and leads - **Automated Workflows**: Set up marketing automation sequences - **Lead Generation**: Capture and nurture leads effectively ### 🔐 Security & Privacy - **Two-Factor Authentication**: Enhanced account security - **Role-Based Access Control**: Manage team permissions - **Data Encryption**: End-to-end encryption for sensitive data - **Privacy Controls**: Granular privacy settings and data management ### 👥 Team Collaboration - **Workspace Management**: Create and manage team workspaces - **Member Invitations**: Invite team members with custom roles - **Collaborative Content**: Work together on content creation - **Approval Workflows**: Set up content approval processes''',
'Installation': '''## 📱 Installation ### System Requirements - **iOS**: Version 12.0 or later - **Android**: API level 21 (Android 5.0) or higher - **Storage**: Minimum 100MB free space - **Internet**: Stable internet connection required ### Download & Install #### From App Stores 1. **iOS App Store** - Search for "Mewayz" in the App Store - Tap "Get" to download and install - Open the app and create your account 2. **Google Play Store** - Search for "Mewayz" in Google Play - Tap "Install" to download the app - Launch the app and begin setup #### Development Setup For developers wanting to contribute or build from source: ```bash # Clone the repository git clone https://github.com/mewayz/mewayz-mobile-app.git # Navigate to project directory cd mewayz-mobile-app # Install Flutter dependencies flutter pub get # Run the application flutter run ``` #### Environment Configuration Create an `env.json` file in the project root: ```json { "SUPABASE_URL": "your_supabase_url", "SUPABASE_ANON_KEY": "your_supabase_anon_key", "API_BASE_URL": "https://api.mewayz.com", "ENVIRONMENT": "production" } ``` ### First-Time Setup 1. **Create Account**: Sign up with email or social media 2. **Goal Selection**: Choose your primary use case 3. **Workspace Setup**: Create your first workspace 4. **Platform Connections**: Connect your social media accounts 5. **Profile Configuration**: Complete your profile setup''',
'Usage': '''## 🎯 How to Use Mewayz ### Getting Started #### 1. Account Setup - **Registration**: Create account with email or social login - **Profile Setup**: Complete your profile information - **Workspace Creation**: Set up your first workspace - **Team Invitation**: Invite team members (optional) #### 2. Platform Integration ```dart // Example: Connecting social media accounts await SocialMediaService.connectInstagram( accessToken: 'your_access_token', userId: 'your_user_id', ); ``` #### 3. Content Creation - Navigate to **Content Creator** - Choose content type (post, story, reel) - Use templates or create from scratch - Add captions, hashtags, and media - Schedule or publish immediately #### 4. Analytics Monitoring - Go to **Analytics Dashboard** - Select time range and metrics - View performance insights - Export reports for stakeholders ### Advanced Features #### Custom Workflows ```dart // Example: Setting up automated posting final workflow = AutomationWorkflow( trigger: ScheduleTrigger( frequency: PostFrequency.daily, time: TimeOfDay(hour: 9, minute: 0), ), actions: [ PostAction( platforms: [Platform.instagram, Platform.twitter], content: dynamicContent, ), ], ); ``` #### Team Collaboration - **Workspace Management**: Create team workspaces - **Role Assignment**: Assign roles (Admin, Editor, Viewer) - **Content Approval**: Set up approval workflows - **Activity Tracking**: Monitor team activities #### E-commerce Integration - **Product Setup**: Add products to marketplace - **Link-in-Bio**: Create landing pages - **QR Codes**: Generate marketing QR codes - **Order Processing**: Manage customer orders ### Best Practices 1. **Content Strategy** - Plan content calendar in advance - Use analytics to optimize posting times - Maintain consistent brand voice - Engage with audience regularly 2. **Team Management** - Define clear roles and responsibilities - Use approval workflows for quality control - Regular team performance reviews - Maintain security protocols 3. **Analytics Utilization** - Monitor key performance indicators - Track competitor activities - Adjust strategy based on insights - Generate regular reports for stakeholders''',
'API Documentation': '''## 🔌 API Documentation ### Authentication All API requests require authentication using JWT tokens. ```dart // Authentication header headers: { 'Authorization': 'Bearer <your_jwt_token>', 'Content-Type': 'application/json', } ``` ### Base URL ``` https://api.mewayz.com/v1 ``` ### Core Endpoints #### User Authentication ```dart // Login POST /auth/login Body: { "email": "user@example.com", "password": "secure_password" } // Register POST /auth/register Body: { "email": "user@example.com", "password": "secure_password", "name": "User Name" } // Refresh Token POST /auth/refresh Body: { "refresh_token": "your_refresh_token" } ``` #### Content Management ```dart // Create Post POST /content/posts Body: { "content": "Post content", "platforms": ["instagram", "twitter"], "scheduled_at": "2024-12-31T10:00:00Z", "media_urls": ["https://example.com/image.jpg"] } // Get Posts GET /content/posts?page=1&limit=20 // Update Post PUT /content/posts/{post_id} Body: { "content": "Updated content", "scheduled_at": "2024-12-31T11:00:00Z" } // Delete Post DELETE /content/posts/{post_id} ``` #### Analytics ```dart // Get Analytics GET /analytics/overview?start_date=2024-01-01&end_date=2024-12-31 // Get Platform Analytics GET /analytics/platforms/{platform}?period=30d // Export Analytics POST /analytics/export Body: { "format": "pdf", "metrics": ["engagement", "reach", "impressions"], "date_range": { "start": "2024-01-01", "end": "2024-12-31" } } ``` #### Workspace Management ```dart // Create Workspace POST /workspaces Body: { "name": "My Workspace", "description": "Workspace description", "settings": { "default_timezone": "UTC", "branding": { "logo_url": "https://example.com/logo.png", "primary_color": "#007bff" } } } // Get Workspaces GET /workspaces // Update Workspace PUT /workspaces/{workspace_id} // Delete Workspace DELETE /workspaces/{workspace_id} ``` ### Error Handling ```dart // Error Response Format { "error": { "code": "VALIDATION_ERROR", "message": "Invalid request parameters", "details": { "field": "email", "issue": "Invalid email format" } } } ``` ### Rate Limiting - **Standard Users**: 100 requests per minute - **Premium Users**: 500 requests per minute - **Enterprise**: 1000 requests per minute ### SDK Integration ```dart // Initialize Mewayz SDK final mewayz = MewayzSDK( apiKey: 'your_api_key', baseUrl: 'https://api.mewayz.com/v1', ); // Use SDK methods final posts = await mewayz.content.getPosts(); final analytics = await mewayz.analytics.getOverview(); ```''',




















'Contributing Guidelines': '''## 🤝 Contributing to Mewayz We welcome contributions from the community! Here's how you can help make Mewayz better. ### 📋 Code of Conduct By participating in this project, you agree to abide by our Code of Conduct: - **Be respectful**: Treat all contributors with respect and kindness - **Be inclusive**: Welcome people of all backgrounds and experience levels - **Be constructive**: Provide helpful feedback and suggestions - **Be collaborative**: Work together to improve the project ### 🛠️ Development Setup 1. **Fork the repository** ```bash git clone https://github.com/your-username/mewayz-mobile-app.git cd mewayz-mobile-app ``` 2. **Install dependencies** ```bash flutter pub get ``` 3. **Set up environment** ```bash cp env.example.json env.json # Edit env.json with your configuration ``` 4. **Run the app** ```bash flutter run --dart-define-from-file=env.json ``` ### 📝 How to Contribute #### 1. Reporting Issues - Use the GitHub issue tracker - Provide detailed description - Include steps to reproduce - Add screenshots if applicable - Specify device and OS version #### 2. Submitting Code Changes 1. **Create a branch** ```bash git checkout -b feature/your-feature-name ``` 2. **Make your changes** - Follow the coding standards - Add tests for new features - Update documentation - Ensure all tests pass 3. **Commit your changes** ```bash git commit -m "Add: Brief description of your changes" ``` 4. **Push to your fork** ```bash git push origin feature/your-feature-name ``` 5. **Create a Pull Request** - Provide clear description - Reference related issues - Include testing instructions ### 🎨 Coding Standards #### Flutter/Dart Guidelines - Use `dart format` for code formatting - Follow official Dart style guide - Use meaningful variable names - Add comments for complex logic - Implement proper error handling #### File Structure ``` lib/ ├── core/           # Core utilities and services ├── presentation/   # UI screens and widgets ├── services/       # Business logic and API calls ├── theme/          # App theming and styling ├── routes/         # Navigation and routing └── widgets/        # Reusable UI components ``` #### Widget Development ```dart // Example widget structure class ExampleWidget extends StatefulWidget { final String title; final VoidCallback? onTap; const ExampleWidget({ super.key,
required this.title,
this.onTap,





}); @override State<ExampleWidget> createState() => _ExampleWidgetState(); } class _ExampleWidgetState extends State<ExampleWidget> { @override Widget build(BuildContext context) { return Container( // Widget implementation ); } } ``` ### 🧪 Testing #### Unit Tests ```bash flutter test ``` #### Widget Tests ```dart testWidgets('ExampleWidget displays title', (WidgetTester tester) async { await tester.pumpWidget( MaterialApp( home: ExampleWidget(title: 'Test Title'),
),
















); expect(find.text('Test Title'), findsOneWidget); }); ``` #### Integration Tests ```bash flutter drive --target=test_driver/app.dart ``` ### 📚 Documentation - Update README.md for new features - Add inline code comments - Create API documentation - Include usage examples - Update changelog ### 🎯 Areas for Contribution 1. **Bug Fixes**: Help resolve existing issues 2. **New Features**: Implement requested features 3. **Performance**: Optimize app performance 4. **UI/UX**: Improve user interface and experience 5. **Testing**: Increase test coverage 6. **Documentation**: Improve project documentation 7. **Localization**: Add support for new languages ### 🏆 Recognition Contributors will be: - Listed in the project contributors - Mentioned in release notes - Eligible for contributor badges - Invited to join the core team (for regular contributors) ### 📞 Getting Help - **GitHub Discussions**: For general questions - **Discord**: Join our community server - **Email**: contribute@mewayz.com - **Documentation**: Check our developer docs Thank you for contributing to Mewayz! 🚀''', 'License Information': '''## 📄 License ### MIT License Copyright (c) 2024 Mewayz Team Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,

































































OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. ### Third-Party Licenses This project includes several third-party libraries and frameworks: #### Flutter Framework - **License**: BSD-3-Clause - **Copyright**: Google Inc. - **Used for**: Cross-platform mobile development #### Supabase - **License**: Apache-2.0 - **Used for**: Backend services and database #### Google Fonts - **License**: SIL Open Font License - **Used for**: Typography and font rendering #### Material Design Icons - **License**: Apache-2.0 - **Used for**: UI icons and graphics #### Cached Network Image - **License**: MIT - **Used for**: Image caching and loading #### FL Chart - **License**: BSD-3-Clause - **Used for**: Data visualization and charts #### Dio HTTP Client - **License**: MIT - **Used for**: HTTP requests and API communication #### Shared Preferences - **License**: BSD-3-Clause - **Used for**: Local data storage #### Connectivity Plus - **License**: BSD-3-Clause - **Used for**: Network connectivity monitoring #### Flutter SVG - **License**: MIT - **Used for**: SVG image rendering #### Sizer - **License**: MIT - **Used for**: Responsive UI design #### Fluttertoast - **License**: MIT - **Used for**: Toast notifications ### Attribution Requirements If you use this software in your project, please include: 1. **Copyright Notice**: Include the original copyright notice 2. **License Text**: Include the full MIT license text 3. **Attribution**: Credit the Mewayz team in your documentation 4. **Third-Party Licenses**: Include licenses for all third-party dependencies ### Commercial Use This software is free for commercial use under the MIT license. You can: - Use it in commercial projects - Modify and distribute it - Sell products built with it - Use it for proprietary software ### Contributions By contributing to this project, you agree that your contributions will be licensed under the same MIT license. ### Disclaimer This software is provided "as is" without warranty of any kind. The authors are not liable for any damages arising from its use. ### Contact For licensing questions, contact: - **Email**: legal@mewayz.com - **Website**: https://mewayz.com/legal - **GitHub**: https://github.com/mewayz/mewayz-mobile-app Last updated: December 2024''', }, }, { 'name': 'Open Source Project', 'description': 'Standard template for open source projects', 'category': 'Open Source', 'icon': Icons.public, 'sections': { 'Project Overview': '''# Project Name A brief description of what this project does and who it's for. ## 🚀 About The Project Here's a blank template to get started: To avoid retyping too much info. Do a search and replace with your text editor for the following: `github_username`, `repo_name`, `twitter_handle`, `linkedin_username`, `email_client`, `email`, `project_title`, `project_description` ### Built With * [![Flutter][Flutter.dev]][Flutter-url] * [![Dart][Dart.dev]][Dart-url]''', 'Features': '''## ✨ Features - Feature 1 - Feature 2 - Feature 3 - Feature 4 ## 🛠️ Built With * Flutter * Dart * Your favorite libraries''', 'Installation': '''## 📦 Installation 1. Clone the repo ```sh git clone https://github.com/your_username_/Project-Name.git ``` 2. Install packages ```sh flutter pub get ``` 3. Run the app ```sh flutter run ```''', 'Usage': '''## 🎯 Usage Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources. _For more examples, please refer to the [Documentation](https://example.com)_''', 'API Documentation': '''## 🔌 API Reference #### Get all items ```http GET /api/items ``` #### Get item ```http GET /api/items/\${id} ``` | Parameter | Type     | Description                       | | :-------- | :------- | :-------------------------------- | | `id`      | `string` | **Required**. Id of item to fetch |''', 'Contributing Guidelines': '''## 🤝 Contributing Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. 1. Fork the Project 2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`) 3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`) 4. Push to the Branch (`git push origin feature/AmazingFeature`) 5. Open a Pull Request''', 'License Information': '''## 📄 License Distributed under the MIT License. See `LICENSE.txt` for more information. ## 📞 Contact Your Name - [@your_twitter](https://twitter.com/your_twitter) - email@example.com Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)''', }, }, { 'name': 'Enterprise Application', 'description': 'Professional template for enterprise applications', 'category': 'Enterprise', 'icon': Icons.business, 'sections': { 'Project Overview': '''# Enterprise Application A comprehensive enterprise solution built with modern technologies and best practices. ## 🏢 Enterprise Overview This application is designed to meet the demanding requirements of enterprise environments, providing scalability, security, and reliability. ### Key Benefits - Enterprise-grade security - Scalable architecture - Comprehensive monitoring - 24/7 support availability''', 'Features': '''## 🎯 Enterprise Features ### Core Functionality - User management and authentication - Role-based access control - Audit logging and compliance - Data encryption and security ### Advanced Features - Real-time analytics - API integration - Custom reporting - Workflow automation ### Enterprise Capabilities - Multi-tenant architecture - High availability - Load balancing - Disaster recovery''', 'Installation': '''## 🚀 Enterprise Installation ### Prerequisites - Enterprise license - Dedicated infrastructure - Security clearance - Administrative access ### Deployment Process 1. Contact enterprise support 2. Schedule installation 3. Configure environment 4. Deploy application 5. Configure monitoring 6. User training''', 'Usage': '''## 📋 Enterprise Usage ### Administrative Tasks - User management - System configuration - Security settings - Performance monitoring ### End User Guide - Login procedures - Feature overview - Best practices - Troubleshooting''', 'API Documentation': '''## 🔌 Enterprise API ### Authentication All API endpoints require enterprise authentication tokens. ### Rate Limiting Enterprise accounts have higher rate limits and SLA guarantees. ### Monitoring All API calls are logged and monitored for security and performance.''', 'Contributing Guidelines': '''## 🤝 Enterprise Contributing ### Internal Development - Follow enterprise coding standards - Complete security reviews - Obtain necessary approvals - Document all changes ### External Contributions - Sign contributor agreement - Pass security screening - Follow enterprise processes''', 'License Information': '''## 📄 Enterprise License This software is licensed under an Enterprise License Agreement. ### Terms - Enterprise use only - No redistribution - Support included - Compliance requirements Contact legal@company.com for licensing questions.''', }, },];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Mobile App', 'Open Source', 'Enterprise'];

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _selectedCategory == 'All'
        ? _templates
        : _templates.where((template) => template['category'] == _selectedCategory).toList();

    return Container(
      height: 80.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.library_books,
                size: 24.sp,
                color: AppTheme.accent,
              ),
              SizedBox(width: 2.w),
              Text(
                'Template Library',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = category),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.accent : AppTheme.border,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Templates list
          Expanded(
            child: ListView.builder(
              itemCount: filteredTemplates.length,
              itemBuilder: (context, index) {
                final template = filteredTemplates[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: InkWell(
                    onTap: () => _selectTemplate(template),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              template['icon'],
                              size: 24.sp,
                              color: AppTheme.accent,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryText,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  template['description'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accent.withAlpha(26),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    template['category'],
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppTheme.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectTemplate(Map<String, dynamic> template) {
    final sections = template['sections'] as Map<String, String>;
    widget.onTemplateSelected(sections);
    Navigator.pop(context);
    
    Fluttertoast.showToast(
      msg: '${template['name']} template applied successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }
}