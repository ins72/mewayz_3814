
import '../../../core/app_export.dart';

class CompletionCelebrationWidget extends StatefulWidget {
  final VoidCallback onContinue;

  const CompletionCelebrationWidget({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<CompletionCelebrationWidget> createState() => _CompletionCelebrationWidgetState();
}

class _CompletionCelebrationWidgetState extends State<CompletionCelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late AnimationController _rotationAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _rotationAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimationController.forward();
    _rotationAnimationController.repeat();
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primaryBackground.withAlpha(242),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Celebration icon
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 3.14159,
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAction,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.celebration,
                            color: Color(0xFF141414),
                            size: 10.w,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Congratulations text
                  Text(
                    '🎉 Congratulations!',
                    style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // Success message
                  Text(
                    'Your Mewayz setup is complete!',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 3.h),
                  
                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      'You\'re all set to start building your online presence and growing your business with Mewayz.',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                        fontSize: 12.sp,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: 6.h),
                  
                  // Continue button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAction,
                          foregroundColor: Color(0xFF141414),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Continue to Dashboard',
                          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: Color(0xFF141414),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}