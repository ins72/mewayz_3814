
import '../../../core/app_export.dart';

class CustomGoalInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomGoalInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomGoalInputWidget> createState() => _CustomGoalInputWidgetState();
}

class _CustomGoalInputWidgetState extends State<CustomGoalInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 30),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.primaryAction,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Describe your custom goal',
                        style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // Input field
                  TextFormField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    maxLines: 3,
                    maxLength: 200,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontSize: 12.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tell us what you want to achieve with Mewayz...',
                      hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                        fontSize: 12.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w),
                        borderSide: BorderSide(
                          color: AppTheme.border,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w),
                        borderSide: BorderSide(
                          color: AppTheme.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w),
                        borderSide: BorderSide(
                          color: AppTheme.primaryAction,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppTheme.primaryBackground,
                      contentPadding: EdgeInsets.all(3.w),
                      counterStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 1.h),
                  
                  // Helper text
                  Text(
                    'This will help us create a customized setup experience for you.',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}