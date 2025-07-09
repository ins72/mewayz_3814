
import '../../../core/app_export.dart';
import '../user_onboarding_screen.dart';
import './feature_preview_card_widget.dart';

class OnboardingStepWidget extends StatefulWidget {
  final OnboardingStepData stepData;
  final bool isActive;

  const OnboardingStepWidget({
    Key? key,
    required this.stepData,
    required this.isActive,
  }) : super(key: key);

  @override
  State<OnboardingStepWidget> createState() => _OnboardingStepWidgetState();
}

class _OnboardingStepWidgetState extends State<OnboardingStepWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    if (widget.isActive) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void didUpdateWidget(OnboardingStepWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _slideAnimationController.reset();
      _fadeAnimationController.reset();
      _startAnimations();
    }
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration
                  _buildIllustration(),

                  SizedBox(height: 4.h),

                  // Title and subtitle
                  _buildTitleSection(),

                  SizedBox(height: 3.h),

                  // Description
                  _buildDescription(),

                  SizedBox(height: 4.h),

                  // Feature preview cards
                  _buildFeaturePreviewCards(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        width: 80.w,
        height: 25.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: _getIllustrationIcon(),
                color: AppTheme.accent,
                size: 15.w,
              ),
              SizedBox(height: 2.h),
              Text(
                widget.stepData.illustration.replaceAll('_', ' ').toUpperCase(),
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.secondaryText,
                  fontSize: 8.sp,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getIllustrationIcon() {
    switch (widget.stepData.illustration) {
      case 'workspace_illustration':
        return 'business_center';
      case 'social_media_illustration':
        return 'share';
      case 'link_bio_illustration':
        return 'link';
      case 'crm_illustration':
        return 'contact_mail';
      case 'marketplace_illustration':
        return 'storefront';
      default:
        return 'info';
    }
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.stepData.title,
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          widget.stepData.subtitle,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.accent,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.stepData.description,
      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.secondaryText,
        fontSize: 12.sp,
        height: 1.5,
      ),
    );
  }

  Widget _buildFeaturePreviewCards() {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.stepData.features.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          return FeaturePreviewCardWidget(
            featureData: widget.stepData.features[index],
            animationDelay: Duration(milliseconds: 200 * index),
          );
        },
      ),
    );
  }
}