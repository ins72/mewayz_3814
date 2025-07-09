
import '../core/app_export.dart';

class CustomLoadingWidget extends StatefulWidget {
  final String? message;
  final Color? color;
  final double? size;

  const CustomLoadingWidget({
    Key? key,
    this.message,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: widget.size ?? 8.w,
                height: widget.size ?? 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color ?? AppTheme.accent,
                      (widget.color ?? AppTheme.accent).withAlpha(77),
                    ],
                    stops: [_animation.value, 1.0],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: (widget.size ?? 8.w) * 0.7,
                    height: (widget.size ?? 8.w) * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.message != null) ...[
            SizedBox(height: 2.h),
            Text(
              widget.message!,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class CustomShimmerWidget extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;

  const CustomShimmerWidget({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  }) : super(key: key);

  @override
  State<CustomShimmerWidget> createState() => _CustomShimmerWidgetState();
}

class _CustomShimmerWidgetState extends State<CustomShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppTheme.surface,
                widget.highlightColor ?? AppTheme.surfaceVariant,
                widget.baseColor ?? AppTheme.surface,
              ],
              stops: [
                (_animation.value - 0.5).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.5).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class CustomSkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? color;

  const CustomSkeletonWidget({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShimmerWidget(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? AppTheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusS),
        ),
      ),
    );
  }
}

class CustomListLoadingWidget extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final EdgeInsets? padding;

  const CustomListLoadingWidget({
    Key? key,
    this.itemCount = 5,
    this.itemHeight,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(4.w),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight ?? 8.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: AppTheme.border.withAlpha(26),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomSkeletonWidget(
                width: 12.w,
                height: 12.w,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSkeletonWidget(
                      width: 60.w,
                      height: 2.h,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    SizedBox(height: 1.h),
                    CustomSkeletonWidget(
                      width: 40.w,
                      height: 1.5.h,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                  ],
                ),
              ),
              CustomSkeletonWidget(
                width: 8.w,
                height: 8.w,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
            ],
          ),
        );
      },
    );
  }
}