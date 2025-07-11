
import '../../../core/app_export.dart';
import '../../../services/enhanced_auth_service.dart';

class EnhancedSecuritySettingsWidget extends StatefulWidget {
  const EnhancedSecuritySettingsWidget({super.key});

  @override
  State<EnhancedSecuritySettingsWidget> createState() => _EnhancedSecuritySettingsWidgetState();
}

class _EnhancedSecuritySettingsWidgetState extends State<EnhancedSecuritySettingsWidget> {
  final EnhancedAuthService _authService = EnhancedAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasPassword = false;
  bool _showPasswordForm = false;
  bool _isBiometricEnabled = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      setState(() {
        _emailController.text = currentUser.email ?? '';
        _hasPassword = !(currentUser.userMetadata?['requires_password_setup'] ?? false);
        _isBiometricEnabled = currentUser.userMetadata?['auth_method'] == 'biometric';
      });
    }
  }

  void _setupMultiDeviceLogin() async {
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Password is required');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 8) {
      _showErrorSnackBar('Password must be at least 8 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.setupPasswordForMultiDevice(
        password: _passwordController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
      );

      setState(() {
        _hasPassword = true;
        _showPasswordForm = false;
        _isLoading = false;
      });

      _showSuccessSnackBar('Multi-device login enabled successfully!');
      
      // Clear password fields
      _passwordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to setup password: ${e.toString()}');
    }
  }

  void _clearBiometricData() async {
    final confirmed = await _showConfirmationDialog(
      title: 'Clear Biometric Data',
      message: 'This will remove biometric authentication from this device. You will need to use your password to sign in.',
    );

    if (confirmed) {
      await _authService.clearBiometricData();
      setState(() {
        _isBiometricEnabled = false;
      });
      _showSuccessSnackBar('Biometric data cleared');
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          title,
          style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Confirm',
              style: GoogleFonts.inter(color: const Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Settings',
            style: GoogleFonts.inter(
              color: const Color(0xFFF1F1F1),
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Current authentication method
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isBiometricEnabled 
                    ? const Color(0xFF007AFF).withAlpha(77)
                    : const Color(0xFF7B7B7B).withAlpha(77),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isBiometricEnabled ? Icons.fingerprint : Icons.password,
                  color: _isBiometricEnabled 
                      ? const Color(0xFF007AFF)
                      : const Color(0xFF7B7B7B),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isBiometricEnabled 
                            ? 'Biometric Authentication'
                            : 'Password Authentication',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFF1F1F1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _isBiometricEnabled 
                            ? 'Using device biometrics for login'
                            : 'Using email and password for login',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7B7B7B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Multi-device login section
          if (!_hasPassword) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFC107)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFFF8F00),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Multi-Device Login',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF795548),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Set up a password to access your account from other devices',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF795548),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            if (!_showPasswordForm) ...[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showPasswordForm = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Setup Password',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            
            if (_showPasswordForm) ...[
              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007AFF)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                ),
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007AFF)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF7B7B7B),
                    ),
                  ),
                ),
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              
              const SizedBox(height: 16),
              
              // Confirm password field
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007AFF)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF7B7B7B),
                    ),
                  ),
                ),
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _showPasswordForm = false;
                        });
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7B7B7B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _setupMultiDeviceLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Save',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ],
          
          if (_hasPassword) ...[
            // Multi-device enabled status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Multi-Device Login Enabled',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2E7D32),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'You can now sign in from other devices using your email and password',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2E7D32),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Biometric data management
          if (_isBiometricEnabled) ...[
            Text(
              'Biometric Data',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 12),
            
            TextButton.icon(
              onPressed: _clearBiometricData,
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF6B6B),
                size: 20,
              ),
              label: Text(
                'Clear Biometric Data',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFF6B6B),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}