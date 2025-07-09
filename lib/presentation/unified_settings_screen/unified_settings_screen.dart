import '../../core/app_export.dart';
import '../account_settings_screen/widgets/privacy_controls_widget.dart';
import '../account_settings_screen/widgets/security_settings_widget.dart';
import '../notification_settings_screen/widgets/notification_category_widget.dart';
import '../notification_settings_screen/widgets/quiet_hours_widget.dart';
import '../profile_settings_screen/widgets/avatar_upload_widget.dart';
import '../profile_settings_screen/widgets/profile_form_widget.dart';
import '../profile_settings_screen/widgets/social_links_widget.dart';

class UnifiedSettingsScreen extends StatefulWidget {
  const UnifiedSettingsScreen({super.key});

  @override
  State<UnifiedSettingsScreen> createState() => _UnifiedSettingsScreenState();
}

class _UnifiedSettingsScreenState extends State<UnifiedSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  // Personal Information
  final _fullNameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _bioController = TextEditingController(text: 'Digital entrepreneur and content creator');

  // Settings States
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-5 (Eastern Time)';
  bool _emailVerified = true;
  bool _twoFactorEnabled = false;
  bool _dataSharing = false;
  bool _marketingCommunications = false;
  bool _enableEmailNotifications = true;
  bool _enablePushNotifications = true;
  bool _enableMarketingEmails = false;
  String _accountVisibility = 'public';

  Map<String, String> _socialLinks = {
    'instagram': '@johndoe',
    'twitter': '@johndoe',
    'linkedin': 'john-doe',
    'youtube': 'johndoe',
  };

  // Active Sessions
  List<Map<String, dynamic>> _activeSessions = [
    {
      'device': 'MacBook Pro',
      'location': 'New York, NY',
      'lastActive': '2 minutes ago',
      'current': true,
    },
    {
      'device': 'iPhone 15',
      'location': 'New York, NY',
      'lastActive': '1 hour ago',
      'current': false,
    },
    {
      'device': 'Windows PC',
      'location': 'Boston, MA',
      'lastActive': '3 days ago',
      'current': false,
    },
  ];

  final List<Map<String, dynamic>> _settingsCategories = [
{ 'title': 'Profile',
'icon': Icons.person_outline,
'items': ['Personal Information', 'Avatar & Display', 'Bio & Social Links'] },
{ 'title': 'Account',
'icon': Icons.account_circle_outlined,
'items': ['Email & Phone', 'Password & Security', 'Two-Factor Authentication'] },
{ 'title': 'Privacy',
'icon': Icons.privacy_tip_outlined,
'items': ['Data Sharing', 'Account Visibility', 'Marketing Communications'] },
{ 'title': 'Notifications',
'icon': Icons.notifications_outlined,
'items': ['Email Notifications', 'Push Notifications', 'Quiet Hours'] },
{ 'title': 'Workspace',
'icon': Icons.business_outlined,
'items': ['Workspace Settings', 'Team Management', 'Billing & Plans'] },
{ 'title': 'System',
'icon': Icons.settings_outlined,
'items': ['Language & Region', 'Theme Settings', 'Data Export'] },
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    _fullNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings updated successfully'),
          backgroundColor: AppTheme.success));
      setState(() {
        _hasChanges = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText)),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasChanges ? AppTheme.primaryAction : AppTheme.border,
                foregroundColor: _hasChanges ? AppTheme.primaryBackground : AppTheme.secondaryText,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500)))),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryText,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.accent,
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Account'),
            Tab(text: 'Privacy'),
            Tab(text: 'Notifications'),
          ])),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildAccountTab(),
            _buildPrivacyTab(),
            _buildNotificationsTab(),
          ])));
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Section
          AvatarUploadWidget(
            onImageChanged: _onFieldChanged),

          const SizedBox(height: 32),

          // Profile Form
          ProfileFormWidget(
            fullNameController: _fullNameController,
            displayNameController: _fullNameController, // Reuse for display
            emailController: _emailController,
            phoneController: _phoneController,
            bioController: _bioController,
            emailVerified: _emailVerified,
            onEmailVerify: () {
              setState(() {
                _emailVerified = true;
              });
            }),

          const SizedBox(height: 32),

          // Social Links
          SocialLinksWidget(
            socialLinks: _socialLinks,
            onLinksChanged: (links) {
              setState(() {
                _socialLinks = links;
              });
              _onFieldChanged();
            }),

          const SizedBox(height: 32),

          // Language & Timezone
          _buildLanguageTimezoneSection(),
        ]));
  }

  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Settings
          SecuritySettingsWidget(
            twoFactorEnabled: _twoFactorEnabled,
            activeSessions: _activeSessions,
            onTwoFactorChanged: (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
              _onFieldChanged();
            },
            onChangePassword: () {
              // TODO: Navigate to change password screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Password change functionality coming soon'),
                  backgroundColor: AppTheme.warning));
            },
            onLogoutDevice: (index) {
              setState(() {
                _activeSessions.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Device logged out successfully'),
                  backgroundColor: AppTheme.success));
            }),

          const SizedBox(height: 32),

          // Account Actions
          _buildAccountActionsSection(),
        ]));
  }

  Widget _buildPrivacyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Privacy Controls
          PrivacyControlsWidget(
            dataSharing: _dataSharing,
            marketingCommunications: _marketingCommunications,
            accountVisibility: _accountVisibility,
            selectedLanguage: _selectedLanguage,
            selectedTimezone: _selectedTimezone,
            onDataSharingChanged: (value) {
              setState(() {
                _dataSharing = value;
              });
              _onFieldChanged();
            },
            onMarketingChanged: (value) {
              setState(() {
                _marketingCommunications = value;
              });
              _onFieldChanged();
            },
            onVisibilityChanged: (value) {
              setState(() {
                _accountVisibility = value;
              });
              _onFieldChanged();
            },
            onLanguageChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
              _onFieldChanged();
            },
            onTimezoneChanged: (value) {
              setState(() {
                _selectedTimezone = value;
              });
              _onFieldChanged();
            }),
        ]));
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Categories
          NotificationCategoryWidget(
            title: 'Email Notifications',
            description: 'Receive notifications via email',
            icon: Icons.email_outlined,
            settings: {'alerts': _enableEmailNotifications},
            onSettingChanged: (key, value) {
              setState(() {
                _enableEmailNotifications = value;
              });
              _onFieldChanged();
            },
            onEnableAll: () {
              setState(() {
                _enableEmailNotifications = true;
              });
              _onFieldChanged();
            },
            onDisableAll: () {
              setState(() {
                _enableEmailNotifications = false;
              });
              _onFieldChanged();
            }),

          const SizedBox(height: 16),

          NotificationCategoryWidget(
            title: 'Push Notifications',
            description: 'Receive push notifications on your device',
            icon: Icons.notifications_outlined,
            settings: {'alerts': _enablePushNotifications},
            onSettingChanged: (key, value) {
              setState(() {
                _enablePushNotifications = value;
              });
              _onFieldChanged();
            },
            onEnableAll: () {
              setState(() {
                _enablePushNotifications = true;
              });
              _onFieldChanged();
            },
            onDisableAll: () {
              setState(() {
                _enablePushNotifications = false;
              });
              _onFieldChanged();
            }),

          const SizedBox(height: 16),

          NotificationCategoryWidget(
            title: 'Marketing Emails',
            description: 'Receive marketing and promotional emails',
            icon: Icons.campaign_outlined,
            settings: {'alerts': _enableMarketingEmails},
            onSettingChanged: (key, value) {
              setState(() {
                _enableMarketingEmails = value;
              });
              _onFieldChanged();
            },
            onEnableAll: () {
              setState(() {
                _enableMarketingEmails = true;
              });
              _onFieldChanged();
            },
            onDisableAll: () {
              setState(() {
                _enableMarketingEmails = false;
              });
              _onFieldChanged();
            }),

          const SizedBox(height: 32),

          // Quiet Hours
          QuietHoursWidget(
            enabled: true,
            startTime: TimeOfDay(hour: 22, minute: 0),
            endTime: TimeOfDay(hour: 7, minute: 0),
            selectedTimezone: _selectedTimezone,
            onChanged: (enabled, start, end, timezone) {
              _onFieldChanged();
            }),
        ]));
  }

  Widget _buildLanguageTimezoneSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language & Region',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          const SizedBox(height: 16),
          
          // Language Selector
          DropdownButtonFormField<String>(
            value: _selectedLanguage,
            decoration: InputDecoration(
              labelText: 'Language',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8))),
            items: ['English', 'Spanish', 'French', 'German', 'Italian']
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              _onFieldChanged();
            }),

          const SizedBox(height: 16),

          // Timezone Selector
          DropdownButtonFormField<String>(
            value: _selectedTimezone,
            decoration: InputDecoration(
              labelText: 'Timezone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8))),
            items: ['UTC-5 (Eastern Time)', 'UTC-6 (Central Time)', 'UTC-7 (Mountain Time)', 'UTC-8 (Pacific Time)']
                .map((tz) => DropdownMenuItem(
                      value: tz,
                      child: Text(tz)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedTimezone = value!;
              });
              _onFieldChanged();
            }),
        ]));
  }

  Widget _buildAccountActionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Actions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          const SizedBox(height: 16),
          
          // Export Data
          ListTile(
            leading: Icon(Icons.download, color: AppTheme.primaryText),
            title: Text('Export Data', style: GoogleFonts.inter(color: AppTheme.primaryText)),
            subtitle: Text('Download your account data', style: GoogleFonts.inter(color: AppTheme.secondaryText)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data export started. You will receive an email when ready.'),
                  backgroundColor: AppTheme.success));
            }),
          
          const Divider(),
          
          // Deactivate Account
          ListTile(
            leading: Icon(Icons.pause_circle_outline, color: AppTheme.warning),
            title: Text('Deactivate Account', style: GoogleFonts.inter(color: AppTheme.warning)),
            subtitle: Text('Temporarily disable your account', style: GoogleFonts.inter(color: AppTheme.secondaryText)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surface,
                  title: Text('Deactivate Account', style: GoogleFonts.inter(color: AppTheme.primaryText)),
                  content: Text('Are you sure you want to deactivate your account? This action can be reversed within 30 days.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Account deactivated successfully'),
                            backgroundColor: AppTheme.warning));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
                      child: const Text('Deactivate')),
                  ]));
            }),
          
          const Divider(),
          
          // Delete Account
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppTheme.error),
            title: Text('Delete Account', style: GoogleFonts.inter(color: AppTheme.error)),
            subtitle: Text('Permanently delete your account', style: GoogleFonts.inter(color: AppTheme.secondaryText)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surface,
                  title: Text('Delete Account', style: GoogleFonts.inter(color: AppTheme.error)),
                  content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Account deletion process started'),
                            backgroundColor: AppTheme.error));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                      child: const Text('Delete')),
                  ]));
            }),
        ]));
  }
}