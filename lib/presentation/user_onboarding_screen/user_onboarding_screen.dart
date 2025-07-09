
import '../../core/app_export.dart';
import './data/onboarding_steps_data.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/progress_indicator_widget.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkOnboardingCompletion();
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
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingStepsData.totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = StorageService();
      await storageService.saveOnboardingCompleted(true);
      
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: EdgeInsets.all(6.w),
              child: ProgressIndicatorWidget(
                currentStep: _currentPage + 1,
                totalSteps: OnboardingStepsData.totalSteps)),

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
              )),

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
                          fontSize: 16.sp)))
                  else
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 16.sp))),

                  // Next/Get Started Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: AppTheme.primaryAction,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM))),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryAction,
                              strokeWidth: 2))
                        : Text(
                            _currentPage == OnboardingStepsData.totalSteps - 1 ? 'Get Started' : 'Next',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))),
                ])),
          ])));
  }
}