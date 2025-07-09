
import '../../../core/app_export.dart';

class FeaturePreviewCardWidget extends StatefulWidget {
  final dynamic featureData;
  final Duration animationDelay;

  const FeaturePreviewCardWidget({
    Key? key,
    required this.featureData,
    this.animationDelay = Duration.zero,
  }) : super(key: key);

  @override
  State<FeaturePreviewCardWidget> createState() =>
      _FeaturePreviewCardWidgetState();
}

class _FeaturePreviewCardWidgetState extends State<FeaturePreviewCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late AnimationController _glowAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startDelayedAnimation();
  }

  void _setupAnimations() {
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startDelayedAnimation() {
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _scaleAnimationController.forward();
        _glowAnimationController.repeat(reverse: true);
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTap() {
    // Show feature preview or quick demo
    _showFeaturePreview();
  }

  void _showFeaturePreview() {
    showDialog(
      context: context,
      builder: (context) => _buildFeaturePreviewDialog(),
    );
  }

  Widget _buildFeaturePreviewDialog() {
    final featureData = widget.featureData as Map<String, dynamic>? ?? {};
    
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Feature icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: featureData['icon'] ?? 'info',
                  color: AppTheme.accent,
                  size: 8.w,
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Feature title
            Text(
              featureData['title'] ?? '',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Feature description
            Text(
              'This feature will help you ${(featureData['description'] ?? '').toString().toLowerCase()}. You can access it from the main dashboard once you complete the setup.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
                fontSize: 11.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Close button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryAction,
                foregroundColor: Color(0xFF141414),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 1.5.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Got it',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: Color(0xFF141414),
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _glowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featureData = widget.featureData as Map<String, dynamic>? ?? {};
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: AppTheme.border,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(
                            alpha: 0.1 * _glowAnimation.value,
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          // Feature icon
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: featureData['icon'] ?? 'info',
                                color: AppTheme.accent,
                                size: 5.w,
                              ),
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Feature details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  featureData['title'] ?? '',
                                  style: AppTheme
                                      .darkTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  featureData['description'] ?? '',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.secondaryText,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tap indicator
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'touch_app',
                                color: AppTheme.accent,
                                size: 4.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}