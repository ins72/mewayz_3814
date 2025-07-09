
import '../../core/app_export.dart';
import '../setup_progress_screen/widgets/completion_celebration_widget.dart';
import '../setup_progress_screen/widgets/progress_overview_widget.dart';
import '../setup_progress_screen/widgets/setup_checklist_widget.dart';
import '../user_onboarding_screen/data/onboarding_steps_data.dart';
import '../user_onboarding_screen/widgets/onboarding_step_widget.dart';
import '../user_onboarding_screen/widgets/progress_indicator_widget.dart';

class UnifiedOnboardingScreen extends StatefulWidget {
  const UnifiedOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedOnboardingScreen> createState() => _UnifiedOnboardingScreenState();
}

class _UnifiedOnboardingScreenState extends State<UnifiedOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  
  final OnboardingService _onboardingService = OnboardingService();
  
  int _currentPage = 0;
  bool _isLoading = false;
  bool _showSetupProgress = false;
  bool _showCelebration = false;
  
  List<Map<String, dynamic>> _setupSteps = [];
  Map<String, dynamic>? _onboardingProgress;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _checkOnboardingCompletion();
  }

  void _setupAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimationController.forward();
  }

  Future<void> _checkOnboardingCompletion() async {
    final storageService = StorageService();
    final isCompleted = await storageService.getOnboardingCompleted();
    
    if (isCompleted) {
      // Navigate directly to workspace dashboard if onboarding is completed
      Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingStepsData.totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _transitionToSetupProgress();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _transitionToSetupProgress();
  }

  Future<void> _transitionToSetupProgress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _onboardingService.initialize();
      
      final steps = await _onboardingService.getSetupChecklist();
      final progress = await _onboardingService.getOnboardingProgress();
      
      setState(() {
        _setupSteps = steps;
        _onboardingProgress = progress;
        _showSetupProgress = true;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.handleError(e);
    }
  }

  Future<void> _updateStepStatus(String stepKey, SetupStepStatus status) async {
    try {
      await _onboardingService.updateSetupStepStatus(stepKey, status);
      
      // Refresh data
      final steps = await _onboardingService.getSetupChecklist();
      final progress = await _onboardingService.getOnboardingProgress();
      
      setState(() {
        _setupSteps = steps;
        _onboardingProgress = progress;
      });
      
      // Check if onboarding is complete
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
      ErrorHandler.handleError(e);
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = StorageService();
      await storageService.saveOnboardingCompleted(true);
      await _onboardingService.completeOnboarding();
      
      // Navigate to goal selection screen
      Navigator.pushReplacementNamed(context, AppRoutes.goalSelectionScreen);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'You can always complete these setup steps later from your dashboard.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Setup',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: const Color(0xFF141414),
            ),
            child: const Text('Skip for Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
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
                    child: _showSetupProgress
                        ? _buildSetupProgressContent()
                        : _buildOnboardingContent(),
                  );
                },
              ),
              
              // Celebration overlay
              if (_showCelebration)
                CompletionCelebrationWidget(
                  onContinue: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingContent() {
    return Column(
      children: [
        // Progress Indicator
        Padding(
          padding: EdgeInsets.all(6.w),
          child: ProgressIndicatorWidget(
            currentStep: _currentPage + 1,
            totalSteps: OnboardingStepsData.totalSteps,
          ),
        ),

        // Page Content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: OnboardingStepsData.totalSteps,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final stepData = OnboardingStepsData.getStep(index);
              return OnboardingStepWidget(
                isActive: _currentPage == index,
                stepData: stepData.toMap(),
              );
            },
          ),
        ),

        // Navigation Buttons
        Padding(
          padding: EdgeInsets.all(6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Previous Button
              if (_currentPage == 0)
                TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 16.sp,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 16.sp,
                    ),
                  ),
                ),

              // Next/Continue Button
              ElevatedButton(
                onPressed: _isLoading ? null : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.primaryAction,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryAction,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentPage == OnboardingStepsData.totalSteps - 1
                            ? 'Continue to Setup'
                            : 'Next',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetupProgressContent() {
    return Column(
      children: [
        // Setup Header
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _showSetupProgress = false;
                }),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.primaryText,
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  'Setup Progress',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
              TextButton(
                onPressed: _skipToMainApp,
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Setup Content
        Expanded(
          child: _isLoading
              ? _buildLoadingState()
              : _buildSetupProgressList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAction),
            strokeWidth: 3,
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading your setup...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupProgressList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Progress overview
          ProgressOverviewWidget(
            progress: _onboardingProgress,
            totalSteps: _setupSteps.length,
            completedSteps: _setupSteps.where((step) => step['status'] == 'completed').length,
          ),
          
          SizedBox(height: 4.h),
          
          // Setup checklist
          SetupChecklistWidget(
            steps: _setupSteps,
            onStepTap: _updateStepStatus,
          ),
          
          SizedBox(height: 4.h),
          
          // Complete setup button
          if (_onboardingProgress != null && 
              (_onboardingProgress!['completion_percentage'] ?? 0) >= 100)
            _buildCompleteSetupButton(),
        ],
      ),
    );
  }

  Widget _buildCompleteSetupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _completeOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryAction,
          foregroundColor: const Color(0xFF141414),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          elevation: 3,
        ),
        child: Text(
          'Complete Setup & Continue',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: const Color(0xFF141414),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}