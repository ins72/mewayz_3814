
import '../core/app_export.dart';

class CustomLoadingWidget extends StatefulWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final String? subMessage;
  final bool showProgress;
  final double? progress;
  final VoidCallback? onCancel;

  const CustomLoadingWidget({
    Key? key,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
    this.subMessage,
    this.showProgress = false,
    this.progress,
    this.onCancel,
  }) : super(key: key);

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading indicator with enhanced styling
            Container(
              width: widget.size ?? 80,
              height: widget.size ?? 80,
              decoration: BoxDecoration(
                color: (widget.color ?? AppTheme.accent).withAlpha(26),
                borderRadius: BorderRadius.circular((widget.size ?? 80) / 2),
              ),
              child: Center(
                child: widget.showProgress && widget.progress != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: (widget.size ?? 80) * 0.7,
                            height: (widget.size ?? 80) * 0.7,
                            child: CircularProgressIndicator(
                              value: widget.progress,
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.color ?? AppTheme.accent,
                              ),
                              backgroundColor: (widget.color ?? AppTheme.accent).withAlpha(51),
                            ),
                          ),
                          Text(
                            '${(widget.progress! * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.color ?? AppTheme.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: (widget.size ?? 80) * 0.6,
                        height: (widget.size ?? 80) * 0.6,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.color ?? AppTheme.accent,
                          ),
                        ),
                      ),
              ),
            ),

            if (widget.showMessage) ...[
              SizedBox(height: AppTheme.spacingL),

              // Main message
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

              if (widget.subMessage != null) ...[
                SizedBox(height: AppTheme.spacingS),
                Text(
                  widget.subMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],

            // Cancel button if provided
            if (widget.onCancel != null) ...[
              SizedBox(height: AppTheme.spacingXl),
              TextButton(
                onPressed: widget.onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.secondaryText,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomProgressLoadingWidget extends StatelessWidget {
  final String? title;
  final String? currentStep;
  final int? currentStepNumber;
  final int? totalSteps;
  final double? progress;
  final List<String>? steps;
  final VoidCallback? onCancel;

  const CustomProgressLoadingWidget({
    Key? key,
    this.title,
    this.currentStep,
    this.currentStepNumber,
    this.totalSteps,
    this.progress,
    this.steps,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress circle
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF007AFF),
                    ),
                    backgroundColor: const Color(0xFF007AFF).withAlpha(51),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentStepNumber != null && totalSteps != null)
                      Text(
                        '$currentStepNumber/$totalSteps',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    if (progress != null)
                      Text(
                        '${(progress! * 100).round()}%',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppTheme.spacingL),

          // Title
          if (title != null)
            Text(
              title!,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

          SizedBox(height: AppTheme.spacingM),

          // Current step
          if (currentStep != null)
            Text(
              currentStep!,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: const Color(0xFF8E8E93),
              ),
              textAlign: TextAlign.center,
            ),

          // Step list
          if (steps != null && steps!.isNotEmpty) ...[
            SizedBox(height: AppTheme.spacingL),
            Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF38383A),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Steps',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  ...steps!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isCompleted = currentStepNumber != null && index < currentStepNumber!;
                    final isCurrent = currentStepNumber != null && index == currentStepNumber! - 1;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFF34C759)
                                  : isCurrent
                                      ? const Color(0xFF007AFF)
                                      : const Color(0xFF636366),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isCompleted
                                  ? Icons.check
                                  : isCurrent
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              step,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: isCompleted || isCurrent
                                    ? Colors.white
                                    : const Color(0xFF8E8E93),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],

          // Cancel button
          if (onCancel != null) ...[
            SizedBox(height: AppTheme.spacingXl),
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8E8E93),
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomSkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const CustomSkeletonLoader({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<CustomSkeletonLoader> createState() => _CustomSkeletonLoaderState();
}

class _CustomSkeletonLoaderState extends State<CustomSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 20,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              colors: const [
                Color(0xFF2C2C2E),
                Color(0xFF48484A),
                Color(0xFF2C2C2E),
              ],
            ),
          ),
        );
      },
    );
  }
}