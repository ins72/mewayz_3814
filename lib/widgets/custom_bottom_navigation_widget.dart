
import '../core/app_export.dart';

class CustomBottomNavigationWidget extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavigationItem> items;

  const CustomBottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationWidget> createState() => _CustomBottomNavigationWidgetState();
}

class _CustomBottomNavigationWidgetState extends State<CustomBottomNavigationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(index);
                    _animationController.forward().then((_) {
                      _animationController.reset();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 1.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accent.withAlpha(38)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: CustomIconWidget(
                            iconName: item.icon,
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.secondaryText,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTheme.darkTheme.textTheme.labelSmall!.copyWith(
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.secondaryText,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final String icon;
  final String label;
  final String? badge;

  const CustomBottomNavigationItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}