import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/settings_category_widget.dart';
import './widgets/settings_search_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _expandedCategories = [];

  final List<Map<String, dynamic>> _settingsCategories = [
{ 'title': 'Account Settings',
'description': 'Manage your profile, preferences, and account details',
'icon': Icons.account_circle_outlined,
'subcategories': [ 'Profile Management',
'Email Preferences',
'Language Settings',
'Time Zone',
'Avatar & Display Name' ] },
{ 'title': 'Workspace Settings',
'description': 'Configure workspace branding, domains, and permissions',
'icon': Icons.business_outlined,
'subcategories': [ 'Workspace Branding',
'Custom Domain',
'Team Permissions',
'Workspace Limits',
'Data Export' ] },
{ 'title': 'Notification Preferences',
'description': 'Control email, push, and in-app notifications',
'icon': Icons.notifications_outlined,
'subcategories': [ 'Email Notifications',
'Push Notifications',
'In-App Alerts',
'Notification Frequency',
'Do Not Disturb' ] },
{ 'title': 'Security & Privacy',
'description': 'Manage passwords, authentication, and privacy settings',
'icon': Icons.security_outlined,
'subcategories': [ 'Password Management',
'Two-Factor Authentication',
'Active Sessions',
'Privacy Settings',
'Data Protection' ] },
{ 'title': 'Billing & Subscriptions',
'description': 'View current plans, usage metrics, and payment methods',
'icon': Icons.payment_outlined,
'subcategories': [ 'Current Subscription',
'Usage Metrics',
'Payment Methods',
'Billing History',
'Upgrade Plans' ] },
{ 'title': 'Integrations',
'description': 'Manage connected services and third-party applications',
'icon': Icons.extension_outlined,
'subcategories': [ 'Connected Apps',
'API Access',
'Webhooks',
'Social Media Accounts',
'Third-Party Services' ] },
{ 'title': 'Support',
'description': 'Access help documentation, contact support, and feedback',
'icon': Icons.help_outline,
'subcategories': [ 'Help Documentation',
'Contact Support',
'Submit Feedback',
'Feature Requests',
'System Status' ] }
];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _settingsCategories;

    return _settingsCategories.where((category) {
      final titleMatch =
          category['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final descriptionMatch = category['description']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final subcategoryMatch = (category['subcategories'] as List<String>)
          .any((sub) => sub.toLowerCase().contains(_searchQuery.toLowerCase()));

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
                padding: const EdgeInsets.only(
                    top: 60, left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios,
                              color: AppTheme.primaryText),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Settings',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingsSearchWidget(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Settings categories list
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    final isExpanded =
                        _expandedCategories.contains(category['title']);

                    return SettingsCategoryWidget(
                      title: category['title'],
                      description: category['description'],
                      icon: category['icon'],
                      subcategories:
                          List<String>.from(category['subcategories']),
                      isExpanded: isExpanded,
                      onToggle: () => _toggleCategory(category['title']),
                      searchQuery: _searchQuery,
                    );
                  },
                ),
              ),
            ],
          ),

          // Quick actions floating button
          const Positioned(
            bottom: 20,
            right: 20,
            child: QuickActionsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, String description, String icon,
      {required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryText,
        ),
      ),
      subtitle: Text(
        description,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.primaryText,
        ),
      ),
      leading: Icon(
        IconData(0xe800 + icon.codeUnitAt(0)),
        color: AppTheme.primaryText,
      ),
      onTap: onTap,
    );
  }
}