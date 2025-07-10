
import '../../core/app_export.dart';
import '../../services/dynamic_data_service.dart';
import './widgets/account_actions_widget.dart';
import './widgets/enhanced_security_settings_widget.dart';
import './widgets/personal_info_widget.dart';
import './widgets/privacy_controls_widget.dart';
import './widgets/security_settings_widget.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers for personal info
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // State variables
  String? _profileImagePath;
  bool _emailVerified = false;
  bool _twoFactorEnabled = false;
  bool _dataSharing = true;
  bool _marketingCommunications = false;
  String _accountVisibility = 'public';
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-5 (Eastern Time)';
  
  // Dynamic data from Supabase
  List<Map<String, dynamic>> _activeSessions = [];
  bool _isLoading = true;
  String _userId = 'demo-user-id'; // This should come from auth context

  final DynamicDataService _dataService = DynamicDataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAccountData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountData() async {
    try {
      setState(() => _isLoading = true);
      
      final data = await _dataService.getAccountSettingsData(_userId);
      
      final userProfile = data['user_profile'] as Map<String, dynamic>? ?? {};
      final sessions = data['active_sessions'] as List? ?? [];
      
      setState(() {
        // Load user profile data
        _fullNameController.text = userProfile['full_name'] ?? 'Demo User';
        _emailController.text = userProfile['email'] ?? 'demo@example.com';
        _phoneController.text = userProfile['phone'] ?? '+1 (555) 123-4567';
        _profileImagePath = userProfile['avatar_url'];
        _emailVerified = userProfile['email_verified'] ?? false;
        _twoFactorEnabled = userProfile['two_factor_enabled'] ?? false;
        _dataSharing = userProfile['data_sharing'] ?? true;
        _marketingCommunications = userProfile['marketing_communications'] ?? false;
        _accountVisibility = userProfile['account_visibility'] ?? 'public';
        _selectedLanguage = userProfile['language'] ?? 'English';
        _selectedTimezone = userProfile['timezone'] ?? 'UTC-5 (Eastern Time)';
        
        // Load active sessions or use defaults
        _activeSessions = sessions.isNotEmpty 
          ? List<Map<String, dynamic>>.from(sessions)
          : _getDefaultSessions();
        
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading account data: $error');
      setState(() {
        _isLoading = false;
        // Initialize with default data
        _fullNameController.text = 'Demo User';
        _emailController.text = 'demo@example.com';
        _phoneController.text = '+1 (555) 123-4567';
        _activeSessions = _getDefaultSessions();
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultSessions() {
    return [
      {
        'device': 'Current Device',
        'location': 'Unknown Location',
        'lastActive': 'Active now',
        'current': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Settings',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accent,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.accent,
          labelStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Security'),
            Tab(text: 'Privacy'),
            Tab(text: 'Account'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.accent,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // Personal Info Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: PersonalInfoWidget(
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    profileImagePath: _profileImagePath,
                    emailVerified: _emailVerified,
                    onImageChanged: (String? imagePath) {
                      setState(() {
                        _profileImagePath = imagePath;
                      });
                    },
                    onEmailVerify: () {
                      setState(() {
                        _emailVerified = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email verification sent!')),
                      );
                    },
                  ),
                ),
                
                // Security Tab - Updated to use enhanced security widget
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const EnhancedSecuritySettingsWidget(),
                      const SizedBox(height: 16),
                      SecuritySettingsWidget(
                        twoFactorEnabled: _twoFactorEnabled,
                        activeSessions: _activeSessions,
                        onTwoFactorChanged: (bool value) {
                          setState(() {
                            _twoFactorEnabled = value;
                          });
                        },
                        onChangePassword: () {
                          // Navigate to password change screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Navigate to password change')),
                          );
                        },
                        onLogoutDevice: (int index) {
                          setState(() {
                            _activeSessions.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Device logged out')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Privacy Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: PrivacyControlsWidget(
                    dataSharing: _dataSharing,
                    marketingCommunications: _marketingCommunications,
                    accountVisibility: _accountVisibility,
                    selectedLanguage: _selectedLanguage,
                    selectedTimezone: _selectedTimezone,
                    onDataSharingChanged: (bool value) {
                      setState(() {
                        _dataSharing = value;
                      });
                    },
                    onMarketingChanged: (bool value) {
                      setState(() {
                        _marketingCommunications = value;
                      });
                    },
                    onVisibilityChanged: (String value) {
                      setState(() {
                        _accountVisibility = value;
                      });
                    },
                    onLanguageChanged: (String value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                    onTimezoneChanged: (String value) {
                      setState(() {
                        _selectedTimezone = value;
                      });
                    },
                  ),
                ),
                
                // Account Actions Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: AccountActionsWidget(
                    onExportData: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data export initiated')),
                      );
                    },
                    onDeactivateAccount: () {
                      _showDeactivateDialog(context);
                    },
                    onDeleteAccount: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deactivate Account'),
          content: const Text('Are you sure you want to temporarily deactivate your account? You can reactivate it later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deactivated')),
                );
              },
              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion process started')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}