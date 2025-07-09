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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
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
  String _selectedTheme = 'dark';

  Map<String, String> _socialLinks = {
    'instagram': '@johndoe',
    'twitter': '@johndoe',
    'linkedin': 'john-doe',
    'youtube': 'johndoe',
    'tiktok': '@johndoe',
    'website': 'https://johndoe.com',
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _setupAnimations();
    _setupControllerListeners();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
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
      HapticFeedback.lightImpact();
      
      // Simulate save with loading state
      setState(() {
        _hasChanges = false;
      });
      
      // Show success animation
      _showSuccessMessage();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Settings updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverFillRemaining(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildProfileTab(),
                          _buildAccountTab(),
                          _buildPrivacyTab(),
                          _buildNotificationsTab(),
                          _buildSystemTab(),
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

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
        ),
      ),
      actions: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: _hasChanges ? AppTheme.accent : AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasChanges ? AppTheme.accent : AppTheme.surface,
                foregroundColor: _hasChanges ? AppTheme.primaryBackground : AppTheme.secondaryText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _hasChanges ? Icons.save : Icons.check,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  const Text('Save'),
                ],
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryText,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryBackground, AppTheme.surface],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.primaryBackground,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.border,
                width: 0.5,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryText,
            unselectedLabelColor: AppTheme.secondaryText,
            indicatorColor: AppTheme.accent,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            isScrollable: true,
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Account'),
              Tab(text: 'Privacy'),
              Tab(text: 'Notifications'),
              Tab(text: 'System'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Profile Picture',
            icon: Icons.person_outline,
            child: AvatarUploadWidget(
              onImageChanged: _onFieldChanged,
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.info_outline,
            child: ProfileFormWidget(
              fullNameController: _fullNameController,
              displayNameController: _fullNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              bioController: _bioController,
              emailVerified: _emailVerified,
              onEmailVerify: () {
                setState(() {
                  _emailVerified = true;
                });
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Social Links',
            icon: Icons.link,
            child: SocialLinksWidget(
              socialLinks: _socialLinks,
              onLinksChanged: (links) {
                setState(() {
                  _socialLinks = links;
                });
                _onFieldChanged();
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Localization',
            icon: Icons.language,
            child: _buildLanguageTimezoneSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Security & Authentication',
            icon: Icons.security,
            child: SecuritySettingsWidget(
              twoFactorEnabled: _twoFactorEnabled,
              activeSessions: _activeSessions,
              onTwoFactorChanged: (value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
                _onFieldChanged();
              },
              onChangePassword: () {
                _showChangePasswordDialog();
              },
              onLogoutDevice: (index) {
                _showLogoutDeviceDialog(index);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Account Management',
            icon: Icons.account_circle,
            child: _buildAccountActionsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Privacy Controls',
            icon: Icons.privacy_tip,
            child: PrivacyControlsWidget(
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
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Data Management',
            icon: Icons.help_outline,
            child: _buildDataManagementSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Notification Preferences',
            icon: Icons.notifications,
            child: Column(
              children: [
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
                  },
                ),
                
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
                  },
                ),
                
                const SizedBox(height: 16),
                
                NotificationCategoryWidget(
                  title: 'Marketing Communications',
                  description: 'Receive marketing and promotional content',
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
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Quiet Hours',
            icon: Icons.bedtime,
            child: QuietHoursWidget(
              enabled: true,
              startTime: const TimeOfDay(hour: 22, minute: 0),
              endTime: const TimeOfDay(hour: 7, minute: 0),
              selectedTimezone: _selectedTimezone,
              onChanged: (enabled, start, end, timezone) {
                _onFieldChanged();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'App Preferences',
            icon: Icons.tune,
            child: _buildAppPreferencesSection(),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionCard(
            title: 'Support & Information',
            icon: Icons.help_outline,
            child: _buildSupportSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(51),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTimezoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language Selector
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            value: _selectedLanguage,
            decoration: InputDecoration(
              labelText: 'Language',
              prefixIcon: const Icon(Icons.language),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppTheme.surfaceVariant,
            ),
            items: ['English', 'Spanish', 'French', 'German', 'Italian']
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              _onFieldChanged();
            },
          ),
        ),

        // Timezone Selector
        DropdownButtonFormField<String>(
          value: _selectedTimezone,
          decoration: InputDecoration(
            labelText: 'Timezone',
            prefixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppTheme.surfaceVariant,
          ),
          items: [
            'UTC-5 (Eastern Time)',
            'UTC-6 (Central Time)',
            'UTC-7 (Mountain Time)',
            'UTC-8 (Pacific Time)'
          ]
              .map((tz) => DropdownMenuItem(
                    value: tz,
                    child: Text(tz),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedTimezone = value!;
            });
            _onFieldChanged();
          },
        ),
      ],
    );
  }

  Widget _buildAccountActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Export Data
        _buildActionTile(
          icon: Icons.download,
          title: 'Export Data',
          subtitle: 'Download your account data',
          onTap: () => _showExportDataDialog(),
          color: AppTheme.accent,
        ),
        
        const SizedBox(height: 16),
        
        // Deactivate Account
        _buildActionTile(
          icon: Icons.pause_circle_outline,
          title: 'Deactivate Account',
          subtitle: 'Temporarily disable your account',
          onTap: () => _showDeactivateAccountDialog(),
          color: AppTheme.warning,
        ),
        
        const SizedBox(height: 16),
        
        // Delete Account
        _buildActionTile(
          icon: Icons.delete_forever,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          onTap: () => _showDeleteAccountDialog(),
          color: AppTheme.error,
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionTile(
          icon: Icons.clear_all,
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          onTap: () => _clearCache(),
          color: AppTheme.accent,
        ),
        
        const SizedBox(height: 16),
        
        _buildActionTile(
          icon: Icons.analytics,
          title: 'Data Usage',
          subtitle: 'View detailed usage statistics',
          onTap: () => _showDataUsage(),
          color: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theme Selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose your preferred theme',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _selectedTheme,
              items: const [
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'auto', child: Text('Auto')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                _onFieldChanged();
              },
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Auto-update preference
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-update',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Automatically update the app',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: true,
              onChanged: (value) {
                _onFieldChanged();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionTile(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTap: () => Navigator.pushNamed(context, AppRoutes.contactUsScreen),
          color: AppTheme.accent,
        ),
        
        const SizedBox(height: 16),
        
        _buildActionTile(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () => _showAboutDialog(),
          color: AppTheme.accent,
        ),
        
        const SizedBox(height: 16),
        
        _buildActionTile(
          icon: Icons.description,
          title: 'Terms & Privacy',
          subtitle: 'Review terms and privacy policy',
          onTap: () => _showTermsAndPrivacy(),
          color: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.secondaryText,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.secondaryText,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text('Password change functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDeviceDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Logout Device',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout from "${_activeSessions[index]['device']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeSessions.removeAt(index);
              });
              _showSuccessMessage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Export Data',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Your data export will be sent to your email address. This may take a few minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Deactivate Account',
          style: GoogleFonts.inter(
            color: AppTheme.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to deactivate your account? This action can be reversed within 30 days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            color: AppTheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    _showSuccessMessage();
  }

  void _showDataUsage() {
    Navigator.pushNamed(context, AppRoutes.analyticsScreen);
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'About Mewayz',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 100'),
            SizedBox(height: 8),
            Text('© 2024 Mewayz Inc.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndPrivacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Terms & Privacy',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text('Terms and Privacy policy coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}