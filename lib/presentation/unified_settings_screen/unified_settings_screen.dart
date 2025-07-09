import '../../core/app_export.dart';

class UnifiedSettingsScreen extends StatefulWidget {
  const UnifiedSettingsScreen({super.key});

  @override
  State<UnifiedSettingsScreen> createState() => _UnifiedSettingsScreenState();
}

class _UnifiedSettingsScreenState extends State<UnifiedSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to profile edit
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Settings Categories
            _buildSettingsCategory(
              'Account',
              Icons.person_outline,
              [
                _buildSettingsItem(
                  'Profile Settings',
                  Icons.person,
                  () {
                    // Navigate to profile settings
                  },
                ),
                _buildSettingsItem(
                  'Security',
                  Icons.security,
                  () {
                    // Navigate to security settings
                  },
                ),
                _buildSettingsItem(
                  'Privacy',
                  Icons.privacy_tip,
                  () {
                    // Navigate to privacy settings
                  },
                ),
              ],
            ),
            
            _buildSettingsCategory(
              'Notifications',
              Icons.help_outline,
              [
                _buildSettingsItem(
                  'Push Notifications',
                  Icons.notifications,
                  () {
                    // Navigate to notification settings
                  },
                ),
                _buildSettingsItem(
                  'Email Notifications',
                  Icons.email,
                  () {
                    // Navigate to email settings
                  },
                ),
              ],
            ),
            
            _buildSettingsCategory(
              'Preferences',
              Icons.tune,
              [
                _buildSettingsItem(
                  'Theme',
                  Icons.dark_mode,
                  () {
                    // Navigate to theme settings
                  },
                ),
                _buildSettingsItem(
                  'Language',
                  Icons.language,
                  () {
                    // Navigate to language settings
                  },
                ),
                _buildSettingsItem(
                  'Accessibility',
                  Icons.accessibility,
                  () {
                    // Navigate to accessibility settings
                  },
                ),
              ],
            ),
            
            _buildSettingsCategory(
              'Support',
              Icons.help_outline,
              [
                _buildSettingsItem(
                  'Help Center',
                  Icons.help,
                  () {
                    // Navigate to help center
                  },
                ),
                _buildSettingsItem(
                  'Contact Support',
                  Icons.contact_support,
                  () {
                    // Navigate to contact support
                  },
                ),
                _buildSettingsItem(
                  'About',
                  Icons.info,
                  () {
                    // Navigate to about page
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Logout Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: TextButton(
                onPressed: () {
                  // Handle logout
                  _showLogoutDialog();
                },
                child: Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsCategory(String title, IconData icon, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: items,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
              },
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}