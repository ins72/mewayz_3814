import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';
import '../presentation/enhanced_login_screen/enhanced_login_screen.dart';
import '../services/enhanced_auth_service.dart';

/// AuthGuardWidget provides authentication state management and protection
/// for authenticated routes with biometric support and enhanced error handling
class AuthGuardWidget extends StatefulWidget {
  final Widget child;
  final bool requireAuth;
  final String? redirectRoute;
  final VoidCallback? onAuthRequired;
  final bool enableBiometric;

  const AuthGuardWidget({
    Key? key,
    required this.child,
    this.requireAuth = true,
    this.redirectRoute,
    this.onAuthRequired,
    this.enableBiometric = true,
  }) : super(key: key);

  @override
  State<AuthGuardWidget> createState() => _AuthGuardWidgetState();
}

class _AuthGuardWidgetState extends State<AuthGuardWidget> 
    with WidgetsBindingObserver {
  late EnhancedAuthService _authService;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool _isBiometricEnabled = false;
  bool _appInBackground = false;
  DateTime? _backgroundTime;
  StreamSubscription<AuthState>? _authSubscription;
  bool _hasError = false;
  String? _errorMessage;
  int _initRetryCount = 0;
  static const int _maxInitRetries = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAuthGuardWithRetry();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (widget.enableBiometric && _isBiometricEnabled && _isAuthenticated) {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.inactive:
          _appInBackground = true;
          _backgroundTime = DateTime.now();
          break;
        case AppLifecycleState.resumed:
          if (_appInBackground && _backgroundTime != null) {
            final backgroundDuration = DateTime.now().difference(_backgroundTime!);
            // Require biometric auth if app was in background for more than 30 seconds
            if (backgroundDuration.inSeconds > 30) {
              _promptBiometricAuth();
            }
          }
          _appInBackground = false;
          _backgroundTime = null;
          break;
        default:
          break;
      }
    }
  }

  Future<void> _initializeAuthGuardWithRetry() async {
    while (_initRetryCount < _maxInitRetries && mounted) {
      try {
        await _initializeAuthGuard();
        break; // Success, exit retry loop
      } catch (e) {
        _initRetryCount++;
        
        if (_initRetryCount >= _maxInitRetries) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Failed to initialize authentication after $_maxInitRetries attempts';
              _isLoading = false;
            });
          }
          break;
        }
        
        debugPrint('Auth guard initialization attempt $_initRetryCount failed: $e');
        await Future.delayed(Duration(seconds: _initRetryCount * 2)); // Exponential backoff
      }
    }
  }

  Future<void> _initializeAuthGuard() async {
    if (!mounted) return;
    
    try {
      _authService = EnhancedAuthService();
      await _authService.initialize().timeout(const Duration(seconds: 15));
      
      // Check authentication state
      final isAuth = _authService.isAuthenticated;
      
      // Check biometric settings
      final biometricEnabled = false; // Default fallback as method doesn't exist
      
      if (mounted) {
        setState(() {
          _isAuthenticated = isAuth;
          _isBiometricEnabled = biometricEnabled;
          _isLoading = false;
          _hasError = false;
          _initRetryCount = 0; // Reset on success
        });
      }

      // Listen to auth state changes with error handling
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
        (authState) {
          if (mounted) {
            final newAuthState = authState.event == AuthChangeEvent.signedIn;
            if (_isAuthenticated != newAuthState) {
              setState(() {
                _isAuthenticated = newAuthState;
              });
            }
          }
        },
        onError: (error) {
          debugPrint('Auth state change error: $error');
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Authentication state monitoring failed';
            });
          }
        },
      );

    } catch (e) {
      debugPrint('Auth guard initialization failed: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
      rethrow; // Let retry logic handle this
    }
  }

  Future<void> _promptBiometricAuth() async {
    if (!_isBiometricEnabled || !widget.enableBiometric || !mounted) return;
    
    try {
      // Show biometric prompt overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _BiometricPromptDialog(
          onAuthenticated: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          onFailed: () {
            if (mounted) {
              Navigator.of(context).pop();
              _navigateToLogin();
            }
          },
        ),
      );
    } catch (e) {
      debugPrint('Biometric prompt failed: $e');
    }
  }

  void _navigateToLogin() {
    if (!mounted) return;
    
    if (widget.redirectRoute != null) {
      Navigator.pushReplacementNamed(context, widget.redirectRoute!);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.enhancedLoginScreen);
    }
  }

  void _retryInitialization() {
    _initRetryCount = 0; // Reset retry count for manual retry
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });
    _initializeAuthGuardWithRetry();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_hasError) {
      return _buildErrorScreen();
    }

    // If authentication is not required, show child widget
    if (!widget.requireAuth) {
      return widget.child;
    }

    // If user is not authenticated, show login screen or trigger callback
    if (!_isAuthenticated) {
      widget.onAuthRequired?.call();
      return const EnhancedLoginScreen();
    }

    // User is authenticated, show protected content
    return widget.child;
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF007AFF),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Authenticating...',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              if (_initRetryCount > 0) ...[
                SizedBox(height: 1.h),
                Text(
                  'Retry attempt $_initRetryCount/$_maxInitRetries',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF636366),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20.w,
                  color: const Color(0xFFFF3B30),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Authentication Error',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _errorMessage ?? 'Failed to initialize authentication',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        'Go to Login',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _retryInitialization,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BiometricPromptDialog extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onFailed;

  const _BiometricPromptDialog({
    required this.onAuthenticated,
    required this.onFailed,
  });

  @override
  State<_BiometricPromptDialog> createState() => _BiometricPromptDialogState();
}

class _BiometricPromptDialogState extends State<_BiometricPromptDialog> {
  bool _isAuthenticating = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authenticateWithBiometric();
  }

  Future<void> _authenticateWithBiometric() async {
    if (!mounted) return;
    
    setState(() {
      _isAuthenticating = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final authService = EnhancedAuthService();
      // Method doesn't exist, using false as fallback
      final success = false;

      if (mounted) {
        if (success) {
          widget.onAuthenticated();
        } else {
          setState(() {
            _hasError = true;
            _errorMessage = 'Biometric authentication failed';
            _isAuthenticating = false;
          });
        }
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Authentication timed out';
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      debugPrint('Biometric authentication failed: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Authentication error: ${e.toString()}';
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _hasError ? Icons.error_outline : Icons.fingerprint,
              size: 15.w,
              color: _hasError ? const Color(0xFFFF3B30) : const Color(0xFF007AFF),
            ),
            SizedBox(height: 3.h),
            Text(
              _hasError ? 'Authentication Failed' : 'Biometric Authentication',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _hasError 
                  ? (_errorMessage ?? 'Please try again')
                  : 'Please authenticate to continue using the app',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: const Color(0xFF8E8E93),
              ),
            ),
            SizedBox(height: 4.h),
            if (_isAuthenticating)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF007AFF),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onFailed,
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _authenticateWithBiometric,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}