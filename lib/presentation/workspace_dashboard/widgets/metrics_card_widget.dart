
import '../../../core/app_export.dart';

class MetricsCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onLongPress;

  const MetricsCardWidget({
    Key? key,
    required this.data,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<MetricsCardWidget> createState() => _MetricsCardWidgetState();
}

class _MetricsCardWidgetState extends State<MetricsCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onLongPress: widget.onLongPress,
              onTap: () {
                // Add tap animation
                _controller.reverse().then((_) {
                  _controller.forward();
                });
              },
              child: Container(
                width: 48.w,
                padding: EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.surface,
                      AppTheme.surfaceVariant,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: AppTheme.border.withAlpha(51),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowDark.withAlpha(26),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppTheme.spacingS),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (widget.data["color"] as Color).withAlpha(51),
                                (widget.data["color"] as Color).withAlpha(26),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            border: Border.all(
                              color: (widget.data["color"] as Color).withAlpha(77),
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: widget.data["icon"] ?? 'analytics',
                            color: widget.data["color"] ?? AppTheme.accent,
                            size: 20,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingS,
                            vertical: AppTheme.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: widget.data["isPositive"]
                                ? AppTheme.success.withAlpha(38)
                                : AppTheme.error.withAlpha(38),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            border: Border.all(
                              color: widget.data["isPositive"]
                                  ? AppTheme.success.withAlpha(77)
                                  : AppTheme.error.withAlpha(77),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: widget.data["isPositive"] 
                                    ? 'trending_up' 
                                    : 'trending_down',
                                color: widget.data["isPositive"]
                                    ? AppTheme.success
                                    : AppTheme.error,
                                size: 12,
                              ),
                              SizedBox(width: AppTheme.spacingXs),
                              Text(
                                widget.data["change"] ?? "+0%",
                                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                  color: widget.data["isPositive"]
                                      ? AppTheme.success
                                      : AppTheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppTheme.spacingL),

                    // Value Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data["value"] ?? "0",
                          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingXs),
                        Text(
                          widget.data["title"] ?? "Metric",
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    SizedBox(height: AppTheme.spacingS),

                    // Progress Indicator (Optional)
                    Container(
                      width: double.infinity,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.border.withAlpha(77),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.7, // Dynamic progress based on data
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.data["color"] ?? AppTheme.accent,
                                (widget.data["color"] as Color? ?? AppTheme.accent).withAlpha(179),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}