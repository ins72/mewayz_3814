
import '../../core/app_export.dart';
import './widgets/completion_celebration_widget.dart';
import './widgets/progress_overview_widget.dart';
import './widgets/setup_checklist_widget.dart';
import './widgets/setup_progress_header_widget.dart';

class SetupProgressScreen extends StatefulWidget {
  const SetupProgressScreen({Key? key}) : super(key: key);

  @override
  State<SetupProgressScreen> createState() => _SetupProgressScreenState();
}

class _SetupProgressScreenState extends State<SetupProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  
  final OnboardingService _onboardingService = OnboardingService.instance;
  
  List<Map<String, dynamic>> _setupSteps = [];
  Map<String, dynamic>? _onboardingProgress;
  bool _isLoading = true;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSetupProgress();
  }

  void _setupAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut));

    _fadeAnimationController.forward();
  }

  Future<void> _loadSetupProgress() async {
    try {
      await _onboardingService.initialize();
      
      final steps = await _onboardingService.getSetupChecklist();
      final progress = await _onboardingService.getOnboardingProgress();
      
      setState(() {
        _setupSteps = steps;
        _onboardingProgress = progress;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Failed to load setup progress: $e');
    }
  }

  Future<void> _updateStepStatus(String stepKey, SetupStepStatus status) async {
    try {
      await _onboardingService.updateSetupStepStatus(stepKey, status);
      
      // Refresh data
      await _loadSetupProgress();
      
      // Check if onboarding is complete
      final progress = _onboardingProgress;
      if (progress != null && progress['is_completed'] == true) {
        setState(() {
          _showCelebration = true;
        });
        
        HapticFeedback.heavyImpact();
        
        // Auto-navigate to dashboard after celebration
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
          }
        });
      }
      
    } catch (e) {
      _showErrorMessage('Failed to update step: $e');
    }
  }

  void _skipToMainApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Skip Setup?',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText)),
        content: Text(
          'You can always complete these setup steps later from your dashboard.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Setup',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: Color(0xFF141414)),
            child: Text('Skip for Now')),
        ]));
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating));
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: Stack(
            children: [
              // Main content
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // Header
                        SetupProgressHeaderWidget(
                          onSkip: _skipToMainApp),
                        
                        // Content
                        Expanded(
                          child: _isLoading
                              ? _buildLoadingState()
                              : _buildSetupContent()),
                      ]));
                }),
              
              // Celebration overlay
              if (_showCelebration)
                CompletionCelebrationWidget(
                  onContinue: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
                  }),
            ]))));
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAction),
            strokeWidth: 3),
          SizedBox(height: 3.h),
          Text(
            'Loading your setup...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 12.sp)),
        ]));
  }

  Widget _buildSetupContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Progress overview
          ProgressOverviewWidget(
            progress: _onboardingProgress,
            totalSteps: _setupSteps.length,
            completedSteps: _setupSteps.where((step) => step['status'] == 'completed').length),
          
          SizedBox(height: 4.h),
          
          // Setup checklist
          SetupChecklistWidget(
            steps: _setupSteps,
            onStepTap: _updateStepStatus),
          
          SizedBox(height: 4.h),
          
          // Complete setup button
          if (_onboardingProgress != null && 
              (_onboardingProgress!['completion_percentage'] ?? 0) >= 100)
            _buildCompleteSetupButton(),
        ]));
  }

  Widget _buildCompleteSetupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _onboardingService.completeOnboarding();
            Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
          } catch (e) {
            _showErrorMessage('Failed to complete onboarding: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          
          foregroundColor: Color(0xFF141414),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w)),
          elevation: 3),
        child: Text(
          'Complete Setup & Continue',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: Color(0xFF141414),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600))));
  }
}