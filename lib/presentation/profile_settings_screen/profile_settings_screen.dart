import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/avatar_upload_widget.dart';
import './widgets/danger_zone_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/profile_form_widget.dart';
import './widgets/profile_preview_widget.dart';
import './widgets/security_info_widget.dart';
import './widgets/social_links_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'John Doe');
  final _displayNameController = TextEditingController(text: 'johndoe');
  final _emailController = TextEditingController(text: 'john@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _bioController =
      TextEditingController(text: 'Digital entrepreneur and content creator');

  String _selectedVisibility = 'public';
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-5 (Eastern Time)';
  bool _emailVerified = true;
  bool _allowEmailContact = true;
  bool _allowPhoneContact = false;
  bool _enableEmailNotifications = true;
  bool _enablePushNotifications = true;
  bool _enableMarketingEmails = false;

  Map<String, String> _socialLinks = {
    'instagram': '@johndoe',
    'twitter': '@johndoe',
    'linkedin': 'john-doe',
    'youtube': 'johndoe',
  };

  bool _hasChanges = false;

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
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.success,
        ),
      );
      setState(() {
        _hasChanges = false;
      });
    }
  }

  void _showProfilePreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfilePreviewWidget(
        fullName: _fullNameController.text,
        displayName: _displayNameController.text,
        bio: _bioController.text,
        socialLinks: _socialLinks,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_onFieldChanged);
    _displayNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section
                  AvatarUploadWidget(
                    onImageChanged: _onFieldChanged,
                  ),

                  const SizedBox(height: 32),

                  // Profile Form
                  ProfileFormWidget(
                    fullNameController: _fullNameController,
                    displayNameController: _displayNameController,
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

                  const SizedBox(height: 32),

                  // Privacy Settings
                  PrivacySettingsWidget(
                    selectedVisibility: _selectedVisibility,
                    allowEmailContact: _allowEmailContact,
                    allowPhoneContact: _allowPhoneContact,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _selectedVisibility = value;
                      });
                      _onFieldChanged();
                    },
                    onEmailContactChanged: (value) {
                      setState(() {
                        _allowEmailContact = value;
                      });
                      _onFieldChanged();
                    },
                    onPhoneContactChanged: (value) {
                      setState(() {
                        _allowPhoneContact = value;
                      });
                      _onFieldChanged();
                    },
                  ),

                  const SizedBox(height: 32),

                  // Social Links
                  SocialLinksWidget(
                    socialLinks: _socialLinks,
                    onLinksChanged: (links) {
                      setState(() {
                        _socialLinks = links;
                      });
                      _onFieldChanged();
                    },
                  ),

                  const SizedBox(height: 32),

                  // Notification Preferences
                  NotificationPreferencesWidget(
                    enableEmailNotifications: _enableEmailNotifications,
                    enablePushNotifications: _enablePushNotifications,
                    enableMarketingEmails: _enableMarketingEmails,
                    selectedLanguage: _selectedLanguage,
                    selectedTimezone: _selectedTimezone,
                    onEmailNotificationsChanged: (value) {
                      setState(() {
                        _enableEmailNotifications = value;
                      });
                      _onFieldChanged();
                    },
                    onPushNotificationsChanged: (value) {
                      setState(() {
                        _enablePushNotifications = value;
                      });
                      _onFieldChanged();
                    },
                    onMarketingEmailsChanged: (value) {
                      setState(() {
                        _enableMarketingEmails = value;
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

                  const SizedBox(height: 32),

                  // Security Info
                  SecurityInfoWidget(),

                  const SizedBox(height: 32),

                  // Danger Zone
                  DangerZoneWidget(),

                  const SizedBox(
                      height: 100), // Space for floating action button
                ],
              ),
            ),
          ),

          // Header with save button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.primaryText,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Profile Settings',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _showProfilePreview,
                      child: Text(
                        'Preview',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _hasChanges ? _saveChanges : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanges
                              ? AppTheme.primaryAction
                              : AppTheme.border,
                          foregroundColor: _hasChanges
                              ? AppTheme.primaryBackground
                              : AppTheme.secondaryText,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
