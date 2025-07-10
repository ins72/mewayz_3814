import '../core/app_export.dart';
import '../services/workspace_service.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;
  final bool requireWorkspace;
  
  const AuthGuard({
    Key? key,
    required this.child,
    this.requireWorkspace = false,
  }) : super(key: key);

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authService = AuthService();
      final isLoggedIn = authService.isAuthenticated;
      
      if (!isLoggedIn) {
        // User is not authenticated, redirect to login
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
        return;
      }
      
      // Check if workspace is required
      if (widget.requireWorkspace) {
        final workspaceService = WorkspaceService();
        final hasWorkspace = await workspaceService.hasUserWorkspace();
        
        if (!hasWorkspace) {
          // No workspace found, redirect to workspace creation
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.workspaceSelectorScreen);
          }
          return;
        }
      }
      
      // User is authenticated and has required workspace, show the child
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication check failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
              SizedBox(height: AppTheme.spacingL),
              Text(
                'Checking authentication...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.error,
              ),
              SizedBox(height: AppTheme.spacingL),
              Text(
                'Authentication Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryText,
                ),
              ),
              SizedBox(height: AppTheme.spacingM),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.spacingL),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context, 
                  AppRoutes.loginScreen,
                ),
                child: Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}