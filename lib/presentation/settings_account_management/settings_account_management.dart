import '../../core/app_export.dart';

class SettingsAccountManagement extends StatefulWidget {
  const SettingsAccountManagement({Key? key}) : super(key: key);

  @override
  State<SettingsAccountManagement> createState() => _SettingsAccountManagementState();
}

class _SettingsAccountManagementState extends State<SettingsAccountManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _expandedCategories = [];

  final List<Map<String, dynamic>> _settingsCategories = [
{ 'title': 'Personal Profile',
'description': 'Avatar, name, email, bio, and social links',
'icon': Icons.person_outline,
'route': '/profile-settings',
'subcategories': [ {'title': 'Profile Picture', 'description': 'Upload and manage your avatar'},
{'title': 'Personal Information', 'description': 'Name, email, phone, bio'},
{'title': 'Social Links', 'description': 'Connect your social media accounts'},
{'title': 'Display Preferences', 'description': 'Language, timezone, theme'},
],
},
{ 'title': 'Account Security',
'description': 'Password, two-factor authentication, active sessions',
'icon': Icons.security_outlined,
'route': '/security-settings',
'subcategories': [ {'title': 'Password Management', 'description': 'Change and reset password'},
{'title': 'Two-Factor Authentication', 'description': 'SMS, email, authenticator app'},
{'title': 'Active Sessions', 'description': 'View and manage active logins'},
{'title': 'Login History', 'description': 'Review recent login activity'},
],
},
{ 'title': 'Workspace Management',
'description': 'Settings, team members, roles, and invitations',
'icon': Icons.business_outlined,
'route': AppRoutes.workspaceSettingsScreen,
'subcategories': [ {'title': 'Workspace Settings', 'description': 'General workspace configuration'},
{'title': 'Team Members', 'description': 'Manage team members and roles'},
{'title': 'Role Management', 'description': 'Create and assign roles'},
{'title': 'Invitations', 'description': 'Send and manage invitations'},
],
},
{ 'title': 'Notification Preferences',
'description': 'Email, push, and in-app alerts across all features',
'icon': Icons.notifications_outlined,
'route': '/notification-settings',
'subcategories': [ {'title': 'Email Notifications', 'description': 'Configure email alerts'},
{'title': 'Push Notifications', 'description': 'Mobile push notifications'},
{'title': 'In-App Alerts', 'description': 'Notifications within the app'},
{'title': 'Quiet Hours', 'description': 'Set do not disturb schedule'},
],
},
{ 'title': 'Privacy & Data',
'description': 'Visibility settings, data export, account deletion',
'icon': Icons.privacy_tip_outlined,
'route': '/account-settings',
'subcategories': [ {'title': 'Visibility Settings', 'description': 'Control who can see your profile'},
{'title': 'Data Export', 'description': 'Download your account data'},
{'title': 'Account Deletion', 'description': 'Permanently delete your account'},
{'title': 'Privacy Controls', 'description': 'Manage data sharing preferences'},
],
},
{ 'title': 'Support & Help',
'description': 'Contact options, documentation, feedback',
'icon': Icons.help_outline,
'route': AppRoutes.contactUsScreen,
'subcategories': [ {'title': 'Contact Support', 'description': 'Get help from our support team'},
{'title': 'Documentation', 'description': 'Browse help articles and guides'},
{'title': 'Submit Feedback', 'description': 'Share your thoughts and suggestions'},
{'title': 'Feature Requests', 'description': 'Request new features'},
],
},
];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _settingsCategories;

    return _settingsCategories.where((category) {
      final titleMatch = category['title']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final descriptionMatch = category['description']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final subcategoryMatch = (category['subcategories'] as List<Map<String, dynamic>>)
          .any((sub) => sub['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()));

      return titleMatch || descriptionMatch || subcategoryMatch;
    }).toList();
  }

  void _toggleCategory(String title) {
    setState(() {
      if (_expandedCategories.contains(title)) {
        _expandedCategories.remove(title);
      } else {
        _expandedCategories.add(title);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _navigateToSetting(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: Stack(
        children: [
          Column(
            children: [
              // Header with search
              Container(
                color: AppTheme.primaryBackground,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 4.w,
                  left: 4.w,
                  right: 4.w,
                  bottom: 4.w,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.primaryText,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Settings & Account',
                          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.w),
                    
                    // Search bar
                    Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search settings...',
                          hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          prefixIcon: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.secondaryText,
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.secondaryText,
                                    size: 20,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings categories list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    final isExpanded = _expandedCategories.contains(category['title']);

                    return _buildCategoryCard(category, isExpanded);
                  },
                ),
              ),
            ],
          ),

          // Quick actions floating button
          Positioned(
            bottom: 5.w,
            right: 5.w,
            child: FloatingActionButton(
              onPressed: () => _showQuickActions(),
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              child: CustomIconWidget(
                iconName: 'flash_on',
                color: AppTheme.primaryAction,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isExpanded) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          // Category header
          ListTile(
            leading: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                category['icon'],
                color: AppTheme.accent,
                size: 5.w,
              ),
            ),
            title: Text(
              category['title'],
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              category['description'],
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            trailing: CustomIconWidget(
              iconName: isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
              color: AppTheme.secondaryText,
              size: 24,
            ),
            onTap: () => _toggleCategory(category['title']),
          ),

          // Subcategories
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: AppTheme.border,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.w),
              child: Column(
                children: (category['subcategories'] as List<Map<String, dynamic>>)
                    .map((subcategory) => _buildSubcategoryItem(subcategory, category['route']))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubcategoryItem(Map<String, dynamic> subcategory, String route) {
    return ListTile(
      leading: SizedBox(width: 10.w),
      title: Text(
        subcategory['title'],
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subcategory['description'],
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.secondaryText,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.secondaryText,
        size: 16,
      ),
      onTap: () => _navigateToSetting(route),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXl),
          topRight: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5.w),
            
            _buildQuickActionItem(
              'Change Password',
              'Update your account password',
              Icons.lock_outline,
              () {
                Navigator.pop(context);
                _navigateToSetting('/security-settings');
              },
            ),
            _buildQuickActionItem(
              'Notification Settings',
              'Manage your notification preferences',
              Icons.notifications_outlined,
              () {
                Navigator.pop(context);
                _navigateToSetting('/notification-settings');
              },
            ),
            _buildQuickActionItem(
              'Privacy Controls',
              'Manage your privacy settings',
              Icons.privacy_tip_outlined,
              () {
                Navigator.pop(context);
                _navigateToSetting('/account-settings');
              },
            ),
            _buildQuickActionItem(
              'Contact Support',
              'Get help from our support team',
              Icons.help_outline,
              () {
                Navigator.pop(context);
                _navigateToSetting(AppRoutes.contactUsScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(String title, String description, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.toString().split('.').last,
        color: AppTheme.accent,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        description,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.secondaryText,
        ),
      ),
      onTap: onTap,
    );
  }
}