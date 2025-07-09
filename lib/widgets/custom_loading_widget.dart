
import '../core/app_export.dart';

/// Optimized loading widget for production performance
class CustomLoadingWidget extends StatefulWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final EdgeInsets? padding;
  final bool isOverlay;
  final Duration animationDuration;
  final LoadingType type;

  const CustomLoadingWidget({
    Key? key,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
    this.padding,
    this.isOverlay = false,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.type = LoadingType.circular,
  }) : super(key: key);

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Main loading animation
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this);

    _animation = Tween<double>(
      begin: 0,
      end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut));

    // Fade animation for overlay
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut));

    // Start animations
    _animationController.repeat();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingColor = widget.color ?? AppTheme.accent;
    final loadingSize = widget.size ?? 6.w;
    final loadingMessage = widget.message ?? 'Loading...';

    Widget loadingWidget = _buildLoadingIndicator(loadingColor, loadingSize);

    if (widget.showMessage) {
      loadingWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          SizedBox(height: 2.h),
          Text(
            loadingMessage,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText),
            textAlign: TextAlign.center),
        ]);
    }

    Widget content = Container(
      padding: widget.padding ?? EdgeInsets.all(4.w),
      child: loadingWidget);

    if (widget.isOverlay) {
      content = FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.primaryBackground.withAlpha(204),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(3.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
                ]),
              padding: EdgeInsets.all(6.w),
              child: loadingWidget))));
    }

    return content;
  }

  Widget _buildLoadingIndicator(Color color, double size) {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularLoading(color, size);
      case LoadingType.linear:
        return _buildLinearLoading(color, size);
      case LoadingType.dots:
        return _buildDotsLoading(color, size);
      case LoadingType.pulse:
        return _buildPulseLoading(color, size);
      case LoadingType.spinner:
        return _buildSpinnerLoading(color, size);
      case LoadingType.wave:
        return _buildWaveLoading(color, size);
    }
  }

  Widget _buildCircularLoading(Color color, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 0.8.w));
  }

  Widget _buildLinearLoading(Color color, double size) {
    return Container(
      width: size * 2,
      height: 1.w,
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withAlpha(51)));
  }

  Widget _buildDotsLoading(Color color, double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_animation.value + delay) % 1.0;
            final scale = 0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2));
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: size * 0.3,
                  height: size * 0.3,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle))));
          }));
      });
  }

  Widget _buildPulseLoading(Color color, double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final scale = 0.8 + (0.2 * _animation.value);
        final opacity = 1.0 - _animation.value;
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(opacity),
              shape: BoxShape.circle)));
      });
  }

  Widget _buildSpinnerLoading(Color color, double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.14159,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withAlpha(51),
                width: 0.8.w)),
            child: CustomPaint(
              painter: SpinnerPainter(
                color: color,
                strokeWidth: 0.8.w))));
      });
  }

  Widget _buildWaveLoading(Color color, double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final delay = index * 0.1;
            final animationValue = (_animation.value + delay) % 1.0;
            final height = (size * 0.3) + (size * 0.4 * (1 - (animationValue - 0.5).abs() * 2));
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0.3.w),
              width: size * 0.2,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size * 0.1)));
          }));
      });
  }
}

/// Loading type enumeration
enum LoadingType {
  circular,
  linear,
  dots,
  pulse,
  spinner,
  wave,
}

/// Custom painter for spinner loading
class SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  SpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      3.14159,
      false,
      paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Optimized loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final LoadingType type;
  final Color? color;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.message,
    this.type = LoadingType.circular,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: CustomLoadingWidget(
              message: message,
              type: type,
              color: color,
              isOverlay: true)),
      ]);
  }
}

/// Shimmer loading widget for list items
class ShimmerLoadingWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoadingWidget({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerLoadingWidget> createState() => _ShimmerLoadingWidgetState();
}

class _ShimmerLoadingWidgetState extends State<ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this);
    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppTheme.primaryBackground;
    final highlightColor = widget.highlightColor ?? AppTheme.accent.withAlpha(26);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(2.w),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value * 3.14159))));
      });
  }
}

/// Loading state manager
class LoadingStateManager {
  static final LoadingStateManager _instance = LoadingStateManager._internal();
  factory LoadingStateManager() => _instance;
  LoadingStateManager._internal();

  final Map<String, bool> _loadingStates = {};
  final List<VoidCallback> _listeners = [];

  void setLoading(String key, bool isLoading) {
    _loadingStates[key] = isLoading;
    _notifyListeners();
  }

  bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  bool get hasAnyLoading {
    return _loadingStates.values.any((isLoading) => isLoading);
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void clear() {
    _loadingStates.clear();
    _notifyListeners();
  }
}