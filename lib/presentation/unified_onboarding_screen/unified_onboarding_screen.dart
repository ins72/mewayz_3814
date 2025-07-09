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
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  Future<void> _checkOnboardingCompletion() async {
    final storageService = StorageService();
    final isCompleted = await storageService.getOnboardingCompleted();
    
    if (isCompleted) {
      Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingStepsData.totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _transitionToSetupProgress();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
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
      
      // Trigger animations for setup progress
      _fadeAnimationController.reset();
      _slideAnimationController.reset();
      _fadeAnimationController.forward();
      _slideAnimationController.forward();
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.handleError(e);
    }
  }

  Future<void> _updateStepStatus(String stepKey, SetupStepStatus status) async {
    try {
      HapticFeedback.lightImpact();
      
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
      
      HapticFeedback.heavyImpact();
      
      // Show celebration and then navigate
      setState(() {
        _showCelebration = true;
      });
      
      await Future.delayed(const Duration(seconds: 2));
      
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Skip Setup?',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'You can always complete these setup steps later from your dashboard.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Setup',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Skip for Now',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryBackground,
                      AppTheme.surface,
                    ],
                  ),
                ),
              ),
              
              // Main content
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _slideAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _showSetupProgress
                            ? _buildSetupProgressContent()
                            : _buildOnboardingContent(),
                      ),
                    ),
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
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ProgressIndicatorWidget(
                currentStep: _currentPage + 1,
                totalSteps: OnboardingStepsData.totalSteps,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Mewayz',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s get you started with your journey',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
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
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnboardingStepWidget(
                  isActive: _currentPage == index,
                  stepData: stepData.toMap(),
                ),
              );
            },
          ),
        ),

        // Navigation Buttons
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Previous Button
              if (_currentPage == 0)
                TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent,
                    ),
                  ),
                ),

              // Next/Continue Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withAlpha(77),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryBackground,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == OnboardingStepsData.totalSteps - 1
                                  ? 'Continue to Setup'
                                  : 'Next',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
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
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _showSetupProgress = false;
                }),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.primaryText,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Progress',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete these steps to get started',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _skipToMainApp,
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Setting up your workspace...',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This won\'t take long',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupProgressList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Progress overview
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.border.withAlpha(77),
                width: 1,
              ),
            ),
            child: ProgressOverviewWidget(
              progress: _onboardingProgress,
              totalSteps: _setupSteps.length,
              completedSteps: _setupSteps.where((step) => step['status'] == 'completed').length,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Setup checklist
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.border.withAlpha(77),
                width: 1,
              ),
            ),
            child: SetupChecklistWidget(
              steps: _setupSteps,
              onStepTap: _updateStepStatus,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Complete setup button
          if (_onboardingProgress != null && 
              (_onboardingProgress!['completion_percentage'] ?? 0) >= 100)
            _buildCompleteSetupButton(),
        ],
      ),
    );
  }

  Widget _buildCompleteSetupButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _completeOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          foregroundColor: AppTheme.primaryBackground,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 24),
            const SizedBox(width: 12),
            Text(
              'Complete Setup & Continue',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}