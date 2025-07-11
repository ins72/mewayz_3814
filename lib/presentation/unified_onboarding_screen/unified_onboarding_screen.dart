import '../../core/app_export.dart';
import '../setup_progress_screen/widgets/completion_celebration_widget.dart';
import '../setup_progress_screen/widgets/progress_overview_widget.dart';
import '../setup_progress_screen/widgets/setup_checklist_widget.dart';

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
  
  final OnboardingService _onboardingService = OnboardingService.instance;
  
  int _currentPage = 0;
  bool _isLoading = false;
  bool _showSetupProgress = false;
  bool _showCelebration = false;
  
  List<Map<String, dynamic>> _setupSteps = [];
  Map<String, dynamic>? _onboardingProgress;

  // Onboarding steps data
  static const int totalSteps = 5;
  
  static const List<Map<String, dynamic>> _onboardingSteps = [
    {
      'title': 'Welcome to Mewayz',
      'description': 'Your all-in-one platform for social media management, analytics, and growth.',
      'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1926&q=80',
      'icon': 'rocket_launch',
      'features': [
        'Social Media Management',
        'Analytics Dashboard',
        'Content Templates',
        'Team Collaboration'
      ]
    },
    {
      'title': 'Smart Social Media Management',
      'description': 'Schedule posts, manage multiple accounts, and engage with your audience across all platforms.',
      'image': 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
      'icon': 'campaign',
      'features': [
        'Multi-platform posting',
        'Content scheduling',
        'Audience engagement',
        'Brand consistency'
      ]
    },
    {
      'title': 'Powerful Analytics & Insights',
      'description': 'Track your performance, understand your audience, and optimize your content strategy.',
      'image': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'icon': 'analytics',
      'features': [
        'Real-time analytics',
        'Performance tracking',
        'Audience insights',
        'Growth metrics'
      ]
    },
    {
      'title': 'Team Collaboration',
      'description': 'Work together with your team, assign roles, and streamline your workflow.',
      'image': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'icon': 'groups',
      'features': [
        'Team workspaces',
        'Role-based access',
        'Collaborative planning',
        'Task management'
      ]
    },
    {
      'title': 'Ready to Get Started?',
      'description': 'Join thousands of businesses that trust Mewayz for their social media success.',
      'image': 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
      'icon': 'celebration',
      'features': [
        'Easy setup process',
        'Comprehensive tutorials',
        '24/7 support',
        'Start free today'
      ]
    }
  ];

  // Add the missing getter for onboardingStepsData
  OnboardingStepsData get onboardingStepsData => OnboardingStepsData();

  static Map<String, dynamic> _getStep(int index) {
    if (index >= 0 && index < _onboardingSteps.length) {
      return _onboardingSteps[index];
    }
    return _onboardingSteps[0];
  }

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
      vsync: this);

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutBack));

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  Future<void> _checkOnboardingCompletion() async {
    final storageService = StorageService();
    final isCompleted = await storageService.getValue('onboarding_completed') == 'true';
    
    if (isCompleted) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardRoute);
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
    if (_currentPage < onboardingStepsData.totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut);
    } else {
      _transitionToSetupProgress();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut);
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
      ErrorHandler.handleError(e.toString());
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
            Navigator.pushReplacementNamed(context, AppRoutes.dashboardRoute);
          }
        });
      }
      
    } catch (e) {
      ErrorHandler.handleError(e.toString());
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = StorageService();
      await storageService.setValue('onboarding_completed', 'true');
      await _onboardingService.completeOnboarding();
      
      HapticFeedback.heavyImpact();
      
      // Show celebration and then navigate
      setState(() {
        _showCelebration = true;
      });
      
      await Future.delayed(const Duration(seconds: 2));
      
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardRoute);
    } catch (e) {
      ErrorHandler.handleError(e.toString());
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
          borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Skip Setup?',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        content: Text(
          'You can always complete these setup steps later from your dashboard.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.secondaryText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Setup',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.dashboardRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Skip for Now',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600),
            ),
          ),
        ]));
  }

  // Progress Indicator Widget
  Widget ProgressIndicatorWidget({
    required int currentStep,
    required int totalSteps,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText)),
            Text(
              '${(currentStep / totalSteps * 100).round()}%',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.accent,
                fontWeight: FontWeight.w600)),
          ]),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: AppTheme.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent)),
        const SizedBox(height: 16),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep - 1;
            final isCurrent = index == currentStep - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppTheme.accent
                            : AppTheme.border,
                        borderRadius: BorderRadius.circular(2)))),
                  if (index < totalSteps - 1) const SizedBox(width: 8),
                ]));
          })),
      ]);
  }

  // Onboarding Step Widget
  Widget OnboardingStepWidget({
    required bool isActive,
    required Map<String, dynamic> stepData,
  }) {
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.8,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          // Feature image
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
              ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: stepData['image'] ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent)))),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.surface,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: AppTheme.secondaryText))))),
          
          const SizedBox(height: 32),
          
          // Step content
          Text(
            stepData['title'] ?? '',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryText),
            textAlign: TextAlign.center),
          
          const SizedBox(height: 16),
          
          Text(
            stepData['description'] ?? '',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.secondaryText,
              height: 1.5),
            textAlign: TextAlign.center),
          
          const SizedBox(height: 32),
          
          // Features list
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.border.withAlpha(77),
                width: 1)),
            child: Column(
              children: [
                ...(stepData['features'] as List<String>? ?? []).map((feature) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withAlpha(51),
                            borderRadius: BorderRadius.circular(8)),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: AppTheme.accent)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            feature,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w500))),
                      ]))),
              ])),
        ]));
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
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryBackground,
                      AppTheme.surface,
                    ]))),
              
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
                            : _buildOnboardingContent())));
                }),
              
              // Celebration overlay
              if (_showCelebration)
                CompletionCelebrationWidget(
                  onContinue: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboardRoute);
                  }),
            ]))));
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
                totalSteps: onboardingStepsData.totalSteps),
              const SizedBox(height: 16),
              Text(
                'Welcome to Mewayz',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryText)),
              const SizedBox(height: 8),
              Text(
                'Let\'s get you started with your journey',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText)),
            ])),

        // Page Content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: onboardingStepsData.totalSteps,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final stepData = onboardingStepsData.getStep(index);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnboardingStepWidget(
                  isActive: _currentPage == index,
                  stepData: stepData));
            })),

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
                      color: AppTheme.secondaryText)))
              else
                TextButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent))),

              // Next/Continue Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withAlpha(77),
                      blurRadius: 16,
                      offset: const Offset(0, 8)),
                  ]),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryBackground,
                            strokeWidth: 2))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == onboardingStepsData.totalSteps - 1
                                  ? 'Continue to Setup'
                                  : 'Next',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ]))),
            ])),
      ]);
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
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.primaryText,
                    size: 20))),
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
                        color: AppTheme.primaryText)),
                    const SizedBox(height: 4),
                    Text(
                      'Complete these steps to get started',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.secondaryText)),
                  ])),
              TextButton(
                onPressed: _skipToMainApp,
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
            ])),

        // Setup Content
        Expanded(
          child: _isLoading
              ? _buildLoadingState()
              : _buildSetupProgressList()),
      ]);
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
              borderRadius: BorderRadius.circular(20)),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              strokeWidth: 3)),
          const SizedBox(height: 32),
          Text(
            'Setting up your workspace...',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
          const SizedBox(height: 8),
          Text(
            'This won\'t take long',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText)),
        ]));
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
                width: 1)),
            child: ProgressOverviewWidget(
              progress: _onboardingProgress,
              totalSteps: _setupSteps.length,
              completedSteps: _setupSteps.where((step) => step['status'] == 'completed').length)),
          
          const SizedBox(height: 24),
          
          // Setup checklist
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.border.withAlpha(77),
                width: 1)),
            child: SetupChecklistWidget(
              steps: _setupSteps,
              onStepTap: (String stepKey, SetupStepStatus status) async {
                await _updateStepStatus(stepKey, status);
              })),
          
          const SizedBox(height: 32),
          
          // Complete setup button
          if (_onboardingProgress != null && 
              (_onboardingProgress!['completion_percentage'] ?? 0) >= 100)
            _buildCompleteSetupButton(),
        ]));
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
            offset: const Offset(0, 8)),
        ]),
      child: ElevatedButton(
        onPressed: _completeOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          foregroundColor: AppTheme.primaryBackground,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
          elevation: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 24),
            const SizedBox(width: 12),
            Text(
              'Complete Setup & Continue',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600)),
          ])));
  }
}

// OnboardingStepsData class to provide compatibility
class OnboardingStepsData {
  static const List<Map<String, dynamic>> _steps = [
    {
      'title': 'Welcome to Mewayz',
      'description': 'Your all-in-one platform for social media management, analytics, and growth.',
      'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1926&q=80',
      'icon': 'rocket_launch',
      'features': [
        'Social Media Management',
        'Analytics Dashboard',
        'Content Templates',
        'Team Collaboration'
      ]
    },
    {
      'title': 'Smart Social Media Management',
      'description': 'Schedule posts, manage multiple accounts, and engage with your audience across all platforms.',
      'image': 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
      'icon': 'campaign',
      'features': [
        'Multi-platform posting',
        'Content scheduling',
        'Audience engagement',
        'Brand consistency'
      ]
    },
    {
      'title': 'Powerful Analytics & Insights',
      'description': 'Track your performance, understand your audience, and optimize your content strategy.',
      'image': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'icon': 'analytics',
      'features': [
        'Real-time analytics',
        'Performance tracking',
        'Audience insights',
        'Growth metrics'
      ]
    },
    {
      'title': 'Team Collaboration',
      'description': 'Work together with your team, assign roles, and streamline your workflow.',
      'image': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'icon': 'groups',
      'features': [
        'Team workspaces',
        'Role-based access',
        'Collaborative planning',
        'Task management'
      ]
    },
    {
      'title': 'Ready to Get Started?',
      'description': 'Join thousands of businesses that trust Mewayz for their social media success.',
      'image': 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
      'icon': 'celebration',
      'features': [
        'Easy setup process',
        'Comprehensive tutorials',
        '24/7 support',
        'Start free today'
      ]
    }
  ];

  int get totalSteps => _steps.length;
  
  Map<String, dynamic> getStep(int index) {
    if (index >= 0 && index < _steps.length) {
      return _steps[index];
    }
    return _steps[0];
  }
}