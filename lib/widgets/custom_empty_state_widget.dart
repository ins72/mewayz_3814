
import '../core/app_export.dart';

class CustomEmptyStateWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? iconColor;
  final Widget? customIcon;
  final List<Widget>? actions;

  const CustomEmptyStateWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.iconName,
    this.buttonText,
    this.onButtonPressed,
    this.iconColor,
    this.customIcon,
    this.actions,
  }) : super(key: key);

  @override
  State<CustomEmptyStateWidget> createState() => _CustomEmptyStateWidgetState();
}

class _CustomEmptyStateWidgetState extends State<CustomEmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
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
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 80.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Section
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: (widget.iconColor ?? AppTheme.accent).withAlpha(26),
                        borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      ),
                      child: Center(
                        child: widget.customIcon ??
                            CustomIconWidget(
                              iconName: widget.iconName ?? 'inbox',
                              color: widget.iconColor ?? AppTheme.accent,
                              size: 48,
                            ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Title
                    Text(
                      widget.title,
                      style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Subtitle
                    if (widget.subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        widget.subtitle!,
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    // Actions
                    if (widget.buttonText != null && widget.onButtonPressed != null) ...[
                      SizedBox(height: 4.h),
                      ElevatedButton(
                        onPressed: widget.onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: AppTheme.primaryAction,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                        ),
                        child: Text(widget.buttonText!),
                      ),
                    ],

                    // Custom Actions
                    if (widget.actions != null) ...[
                      SizedBox(height: 4.h),
                      ...widget.actions!,
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomNoDataWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;

  const CustomNoDataWidget({
    Key? key,
    this.title,
    this.subtitle,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEmptyStateWidget(
      title: title ?? 'No Data Available',
      subtitle: subtitle ?? 'There\'s nothing to show here yet.',
      iconName: 'inbox',
      iconColor: AppTheme.secondaryText,
      buttonText: onRetry != null ? 'Retry' : null,
      onButtonPressed: onRetry,
    );
  }
}

class CustomNetworkErrorWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;

  const CustomNetworkErrorWidget({
    Key? key,
    this.title,
    this.subtitle,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEmptyStateWidget(
      title: title ?? 'Connection Error',
      subtitle: subtitle ?? 'Please check your internet connection and try again.',
      iconName: 'wifi_off',
      iconColor: AppTheme.error,
      buttonText: 'Retry',
      onButtonPressed: onRetry,
    );
  }
}

class CustomSearchEmptyWidget extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const CustomSearchEmptyWidget({
    Key? key,
    this.searchQuery,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEmptyStateWidget(
      title: 'No Results Found',
      subtitle: searchQuery != null
          ? 'No results found for "$searchQuery"'
          : 'Try adjusting your search criteria',
      iconName: 'search_off',
      iconColor: AppTheme.secondaryText,
      buttonText: onClearSearch != null ? 'Clear Search' : null,
      onButtonPressed: onClearSearch,
    );
  }
}