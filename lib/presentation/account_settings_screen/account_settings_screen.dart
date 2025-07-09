import '../../core/app_export.dart';
import './widgets/account_actions_widget.dart';
import './widgets/personal_info_widget.dart';
import './widgets/privacy_controls_widget.dart';
import './widgets/security_settings_widget.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  // Personal Information
  final _fullNameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  String? _profileImagePath;

  // Security Settings
  bool _twoFactorEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-5 (Eastern Time)';
  bool _emailVerified = true;

  // Privacy Controls
  bool _dataSharing = false;
  bool _marketingCommunications = false;
  String _accountVisibility = 'public';

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
          content: Text('Account settings updated successfully'),
          backgroundColor: AppTheme.success,
        ),
      );
      setState(() {
        _hasChanges = false;
      });
    }
  }

  void _changePassword() {
    // TODO: Navigate to change password screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password change functionality coming soon'),
        backgroundColor: AppTheme.warning,
      ),
    );
  }

  void _logoutDevice(int index) {
    setState(() {
      _activeSessions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device logged out successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _exportData() {
    // TODO: Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Data export started. You will receive an email when ready.'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _deactivateAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Deactivate Account',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to deactivate your account? This action can be reversed within 30 days.',
          style: GoogleFonts.inter(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement deactivation logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deactivated successfully'),
                  backgroundColor: AppTheme.warning,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              foregroundColor: AppTheme.primaryBackground,
            ),
            child: Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
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
        content: Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
          style: GoogleFonts.inter(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement deletion logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion process started'),
                  backgroundColor: AppTheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.primaryText,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                  // Personal Information
                  PersonalInfoWidget(
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    profileImagePath: _profileImagePath,
                    emailVerified: _emailVerified,
                    onImageChanged: (path) {
                      setState(() {
                        _profileImagePath = path;
                      });
                      _onFieldChanged();
                    },
                    onEmailVerify: () {
                      setState(() {
                        _emailVerified = true;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

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
                    onChangePassword: _changePassword,
                    onLogoutDevice: _logoutDevice,
                  ),

                  const SizedBox(height: 32),

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
                    },
                  ),

                  const SizedBox(height: 32),

                  // Account Actions
                  AccountActionsWidget(
                    onExportData: _exportData,
                    onDeactivateAccount: _deactivateAccount,
                    onDeleteAccount: _deleteAccount,
                  ),

                  const SizedBox(height: 100),
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
                        'Account Settings',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ),
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