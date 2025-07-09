
import '../../../core/app_export.dart';

class ProgressOverviewWidget extends StatefulWidget {
  final Map<String, dynamic>? progress;
  final int totalSteps;
  final int completedSteps;

  const ProgressOverviewWidget({
    Key? key,
    this.progress,
    required this.totalSteps,
    required this.completedSteps,
  }) : super(key: key);

  @override
  State<ProgressOverviewWidget> createState() => _ProgressOverviewWidgetState();
}

class _ProgressOverviewWidgetState extends State<ProgressOverviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupProgressAnimation();
  }

  void _setupProgressAnimation() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercentage = widget.progress?['completion_percentage']?.toDouble() ?? 0.0;
    final normalizedProgress = (progressPercentage / 100).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Setup Progress',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAction.withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  '${progressPercentage.toInt()}%',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primaryAction,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: normalizedProgress * _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryAction,
                          AppTheme.accent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 2.h),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                'Completed',
                '${widget.completedSteps}',
                AppTheme.primaryAction,
              ),
              _buildStatItem(
                'Remaining',
                '${widget.totalSteps - widget.completedSteps}',
                AppTheme.secondaryText,
              ),
              _buildStatItem(
                'Total Steps',
                '${widget.totalSteps}',
                AppTheme.primaryText,
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Motivational message
          _buildMotivationalMessage(progressPercentage),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.secondaryText,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalMessage(double progressPercentage) {
    String message;
    Color messageColor;
    
    if (progressPercentage >= 100) {
      message = '🎉 Congratulations! Your setup is complete!';
      messageColor = AppTheme.primaryAction;
    } else if (progressPercentage >= 75) {
      message = '🚀 Almost there! Just a few more steps to go.';
      messageColor = AppTheme.accent;
    } else if (progressPercentage >= 50) {
      message = '💪 Great progress! You\'re halfway there.';
      messageColor = AppTheme.primaryAction;
    } else if (progressPercentage >= 25) {
      message = '👍 Good start! Keep going to unlock all features.';
      messageColor = AppTheme.secondaryText;
    } else {
      message = '🌟 Let\'s get started! Each step brings you closer to success.';
      messageColor = AppTheme.primaryText;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: messageColor.withAlpha(26),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Text(
        message,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: messageColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}