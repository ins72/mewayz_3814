
import '../../../core/app_export.dart';

class DocumentationSectionWidget extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final String content;
  final bool isCompleted;

  const DocumentationSectionWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    required this.onToggle,
    required this.content,
    required this.isCompleted,
  });

  @override
  State<DocumentationSectionWidget> createState() => _DocumentationSectionWidgetState();
}

class _DocumentationSectionWidgetState extends State<DocumentationSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DocumentationSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: widget.isSelected ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSelected ? AppTheme.accent : AppTheme.border,
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color: AppTheme.accent.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: widget.isCompleted
                          ? AppTheme.success.withAlpha(51)
                          : AppTheme.accent.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.isCompleted ? Icons.check_circle : widget.icon,
                      size: 20.sp,
                      color: widget.isCompleted ? AppTheme.success : AppTheme.accent,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryText,
                                ),
                              ),
                            ),
                            if (widget.isCompleted)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withAlpha(51),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.success,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.description,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: widget.onToggle,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    color: AppTheme.border,
                    margin: EdgeInsets.only(bottom: 2.h),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description,
                              size: 12.sp,
                              color: AppTheme.accent,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Content Preview',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.content.length} chars',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.content.isEmpty
                          ? 'No content yet. Click to start editing this section.'
                          : widget.content.length > 150
                              ? '${widget.content.substring(0, 150)}...'
                              : widget.content,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: widget.content.isEmpty
                            ? AppTheme.secondaryText
                            : AppTheme.primaryText,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: AppTheme.primaryAction,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.content.isEmpty ? 'Start Writing' : 'Edit Section',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.border,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => _showQuickActions(context),
                          icon: Icon(
                            Icons.more_vert,
                            size: 16.sp,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Section Actions',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 2.h),
            _buildActionButton(
              icon: Icons.copy,
              title: 'Copy Content',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionButton(
              icon: Icons.auto_fix_high,
              title: 'Auto-generate Content',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionButton(
              icon: Icons.help_outline,
              title: 'Use Template',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionButton(
              icon: Icons.clear,
              title: 'Clear Content',
              onTap: () => Navigator.pop(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isDestructive ? AppTheme.error : AppTheme.accent,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppTheme.error : AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}