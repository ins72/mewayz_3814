
import '../../../core/app_export.dart';

class SetupStepCardWidget extends StatefulWidget {
  final Map<String, dynamic> step;
  final Function(SetupStepStatus) onStatusChange;
  final Duration animationDelay;

  const SetupStepCardWidget({
    Key? key,
    required this.step,
    required this.onStatusChange,
    this.animationDelay = Duration.zero,
  }) : super(key: key);

  @override
  State<SetupStepCardWidget> createState() => _SetupStepCardWidgetState();
}

class _SetupStepCardWidgetState extends State<SetupStepCardWidget>
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
      duration: const Duration(milliseconds: 400),
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

    // Start animation with delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  SetupStepStatus get _currentStatus {
    final statusString = widget.step['status'] as String;
    switch (statusString) {
      case 'completed':
        return SetupStepStatus.completed;
      case 'in_progress':
        return SetupStepStatus.inProgress;
      case 'skipped':
        return SetupStepStatus.skipped;
      default:
        return SetupStepStatus.pending;
    }
  }

  Color get _statusColor {
    switch (_currentStatus) {
      case SetupStepStatus.completed:
        return AppTheme.primaryAction;
      case SetupStepStatus.inProgress:
        return AppTheme.accent;
      case SetupStepStatus.skipped:
        return AppTheme.secondaryText;
      default:
        return AppTheme.border;
    }
  }

  IconData get _statusIcon {
    switch (_currentStatus) {
      case SetupStepStatus.completed:
        return Icons.check_circle;
      case SetupStepStatus.inProgress:
        return Icons.radio_button_unchecked;
      case SetupStepStatus.skipped:
        return Icons.skip_next;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  String get _statusText {
    switch (_currentStatus) {
      case SetupStepStatus.completed:
        return 'Completed';
      case SetupStepStatus.inProgress:
        return 'In Progress';
      case SetupStepStatus.skipped:
        return 'Skipped';
      default:
        return 'Pending';
    }
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => _buildActionSheet(),
    );
  }

  Widget _buildActionSheet() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(0.25.h),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Title
          Text(
            widget.step['step_title'] ?? 'Setup Step',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Actions
          if (_currentStatus != SetupStepStatus.completed)
            _buildActionButton(
              'Mark as Complete',
              Icons.check_circle,
              AppTheme.primaryAction,
              () {
                Navigator.pop(context);
                widget.onStatusChange(SetupStepStatus.completed);
              },
            ),
          
          if (_currentStatus != SetupStepStatus.inProgress)
            _buildActionButton(
              'Mark as In Progress',
              Icons.radio_button_unchecked,
              AppTheme.accent,
              () {
                Navigator.pop(context);
                widget.onStatusChange(SetupStepStatus.inProgress);
              },
            ),
          
          if (_currentStatus != SetupStepStatus.skipped)
            _buildActionButton(
              'Skip This Step',
              Icons.skip_next,
              AppTheme.secondaryText,
              () {
                Navigator.pop(context);
                widget.onStatusChange(SetupStepStatus.skipped);
              },
            ),
          
          if (_currentStatus != SetupStepStatus.pending)
            _buildActionButton(
              'Reset to Pending',
              Icons.restore,
              AppTheme.border,
              () {
                Navigator.pop(context);
                widget.onStatusChange(SetupStepStatus.pending);
              },
            ),
          
          SizedBox(height: 2.h),
          
          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withAlpha(26),
          foregroundColor: color,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
      ),
    );
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
            child: GestureDetector(
              onTap: _showActionSheet,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: _statusColor.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Status icon
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _statusColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Icon(
                        _statusIcon,
                        color: _statusColor,
                        size: 20,
                      ),
                    ),
                    
                    SizedBox(width: 3.w),
                    
                    // Step content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.step['step_title'] ?? 'Setup Step',
                            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryText,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.step['step_description'] != null) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              widget.step['step_description'],
                              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.secondaryText,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        _statusText,
                        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: _statusColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
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