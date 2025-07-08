import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/progress_indicator_widget.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isAnimating = false;

  final List<OnboardingStepData> _onboardingSteps = [
    OnboardingStepData(
      title: 'Welcome to Mewayz',
      subtitle: 'Your All-in-One Business Platform',
      description:
          'Create multiple workspaces for different projects and collaborate with your team seamlessly.',
      illustration: 'workspace_illustration',
      features: [
        FeaturePreviewData(
          icon: 'business',
          title: 'Multi-Workspace',
          description: 'Organize projects separately',
        ),
        FeaturePreviewData(
          icon: 'group',
          title: 'Team Collaboration',
          description: 'Invite and manage team members',
        ),
        FeaturePreviewData(
          icon: 'security',
          title: 'Role-Based Access',
          description: 'Control permissions per workspace',
        ),
      ],
    ),
    OnboardingStepData(
      title: 'Social Media Management',
      subtitle: 'Streamline Your Online Presence',
      description:
          'Schedule posts, manage multiple platforms, and analyze performance all in one place.',
      illustration: 'social_media_illustration',
      features: [
        FeaturePreviewData(
          icon: 'schedule',
          title: 'Smart Scheduling',
          description: 'Auto-post at optimal times',
        ),
        FeaturePreviewData(
          icon: 'analytics',
          title: 'Performance Tracking',
          description: 'Monitor engagement metrics',
        ),
        FeaturePreviewData(
          icon: 'content_copy',
          title: 'Content Templates',
          description: 'Pre-made post templates',
        ),
      ],
    ),
    OnboardingStepData(
      title: 'Link in Bio Builder',
      subtitle: 'Create Beautiful Bio Pages',
      description:
          'Build stunning, mobile-optimized link pages with drag-and-drop simplicity.',
      illustration: 'link_bio_illustration',
      features: [
        FeaturePreviewData(
          icon: 'drag_handle',
          title: 'Drag & Drop',
          description: 'Visual page builder',
        ),
        FeaturePreviewData(
          icon: 'phone_android',
          title: 'Mobile Optimized',
          description: 'Perfect on all devices',
        ),
        FeaturePreviewData(
          icon: 'qr_code',
          title: 'QR Code Generator',
          description: 'Share your page offline',
        ),
      ],
    ),
    OnboardingStepData(
      title: 'CRM & Email Marketing',
      subtitle: 'Nurture Your Leads',
      description:
          'Manage contacts, track interactions, and create automated email campaigns.',
      illustration: 'crm_illustration',
      features: [
        FeaturePreviewData(
          icon: 'contacts',
          title: 'Contact Management',
          description: 'Organize and track leads',
        ),
        FeaturePreviewData(
          icon: 'email',
          title: 'Email Campaigns',
          description: 'Automated marketing flows',
        ),
        FeaturePreviewData(
          icon: 'trending_up',
          title: 'Lead Scoring',
          description: 'Prioritize hot prospects',
        ),
      ],
    ),
    OnboardingStepData(
      title: 'Marketplace & Courses',
      subtitle: 'Monetize Your Expertise',
      description:
          'Create online courses, sell products, and build your community all in one platform.',
      illustration: 'marketplace_illustration',
      features: [
        FeaturePreviewData(
          icon: 'store',
          title: 'Online Store',
          description: 'Sell digital & physical products',
        ),
        FeaturePreviewData(
          icon: 'school',
          title: 'Course Creation',
          description: 'Build engaging learning experiences',
        ),
        FeaturePreviewData(
          icon: 'group_work',
          title: 'Community Building',
          description: 'Foster engagement and discussions',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupProgressAnimation();
    _saveOnboardingProgress();
  }

  void _setupProgressAnimation() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimationController.forward();
  }

  void _saveOnboardingProgress() {
    // Save current progress for interrupted sessions
    // In real implementation, save to SharedPreferences or secure storage
  }

  Future<void> _nextStep() async {
    if (_isAnimating) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _isAnimating = true;
      });

      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _currentStep++;
        _isAnimating = false;
      });

      _triggerHapticFeedback();
      _saveOnboardingProgress();
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _previousStep() async {
    if (_isAnimating || _currentStep == 0) return;

    setState(() {
      _isAnimating = true;
    });

    await _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _currentStep--;
      _isAnimating = false;
    });

    _triggerHapticFeedback();
    _saveOnboardingProgress();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  void _skipOnboarding() {
    _showSkipDialog();
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Skip Onboarding?',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to skip the tour? You can always access help from the settings menu.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _completeOnboarding();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: Color(0xFF141414),
            ),
            child: Text('Skip'),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    // In real implementation, save to SharedPreferences
    Navigator.pushReplacementNamed(context, '/workspace-dashboard');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
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
          child: Column(
            children: [
              // Header with skip button and progress
              _buildHeader(),

              // Main content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                    _triggerHapticFeedback();
                    _saveOnboardingProgress();
                  },
                  itemCount: _totalSteps,
                  itemBuilder: (context, index) {
                    return OnboardingStepWidget(
                      stepData: _onboardingSteps[index],
                      isActive: index == _currentStep,
                    );
                  },
                ),
              ),

              // Navigation controls
              _buildNavigationControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Skip button and progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress indicator
              ProgressIndicatorWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),

              // Skip button
              TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.secondaryText,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                ),
                child: Text(
                  'Skip Tour',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: 100.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(0.25.h),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentStep + 1) /
                      _totalSteps *
                      _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryText,
                      borderRadius: BorderRadius.circular(0.25.h),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppTheme.surface,
                foregroundColor: AppTheme.primaryText,
                side: BorderSide(color: AppTheme.border),
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: Text(
                'Previous',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            )
          else
            SizedBox(width: 20.w),

          // Next/Get Started button
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: Color(0xFF141414),
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 2.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
              elevation: 2,
            ),
            child: Text(
              _currentStep == _totalSteps - 1 ? 'Get Started' : 'Next',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: Color(0xFF141414),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStepData {
  final String title;
  final String subtitle;
  final String description;
  final String illustration;
  final List<FeaturePreviewData> features;

  OnboardingStepData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.illustration,
    required this.features,
  });
}

class FeaturePreviewData {
  final String icon;
  final String title;
  final String description;

  FeaturePreviewData({
    required this.icon,
    required this.title,
    required this.description,
  });
}