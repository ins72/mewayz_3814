
import '../../../core/app_export.dart';

class GoalOptionCardWidget extends StatefulWidget {
  final OnboardingGoal goal;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDelay;

  const GoalOptionCardWidget({
    Key? key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
    this.animationDelay = Duration.zero,
  }) : super(key: key);

  @override
  State<GoalOptionCardWidget> createState() => _GoalOptionCardWidgetState();
}

class _GoalOptionCardWidgetState extends State<GoalOptionCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation with delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  String _getGoalIcon() {
    switch (widget.goal) {
      case OnboardingGoal.sellProducts:
        return 'store';
      case OnboardingGoal.showcaseWork:
        return 'work';
      case OnboardingGoal.acceptPayments:
        return 'payment';
      case OnboardingGoal.buildBrand:
        return 'branding';
      case OnboardingGoal.bookAppointments:
        return 'schedule';
      case OnboardingGoal.other:
        return 'more_horiz';
    }
  }

  String _getGoalDescription() {
    switch (widget.goal) {
      case OnboardingGoal.sellProducts:
        return 'Create an online store and sell digital or physical products';
      case OnboardingGoal.showcaseWork:
        return 'Display your portfolio and professional achievements';
      case OnboardingGoal.acceptPayments:
        return 'Set up payment processing for services and donations';
      case OnboardingGoal.buildBrand:
        return 'Establish your personal or business brand online';
      case OnboardingGoal.bookAppointments:
        return 'Allow clients to schedule meetings and consultations';
      case OnboardingGoal.other:
        return 'Define your custom goals and objectives';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildCard(),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppTheme.primaryAction.withAlpha(26) : AppTheme.surface,
          border: Border.all(
            color: widget.isSelected ? AppTheme.primaryAction : AppTheme.border,
            width: widget.isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: widget.isSelected 
                    ? AppTheme.primaryAction.withAlpha(51) 
                    : AppTheme.border.withAlpha(77),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: _getGoalIcon(),
                color: widget.isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
                size: 24,
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Title
            Text(
              widget.goal.title,
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: widget.isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 1.h),
            
            // Description
            Text(
              _getGoalDescription(),
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
                fontSize: 8.sp,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Selection indicator
            if (widget.isSelected) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAction,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Color(0xFF141414),
                  size: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}