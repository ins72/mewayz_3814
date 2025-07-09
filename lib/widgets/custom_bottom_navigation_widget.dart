
import '../core/app_export.dart';

class CustomBottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;
  final bool enableHapticFeedback;

  const CustomBottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
    this.enableHapticFeedback = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bottom navigation with ${items.length} tabs',
      container: true,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: elevation ?? 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: showLabels ? 8.h : 7.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = currentIndex == index;
                
                return _buildNavigationItem(
                  item: item,
                  isSelected: isSelected,
                  index: index,
                  onTap: () {
                    if (enableHapticFeedback) {
                      HapticFeedback.lightImpact();
                    }
                    onTap(index);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BottomNavigationItem item,
    required bool isSelected,
    required int index,
    required VoidCallback onTap,
  }) {
    final selectedColor = selectedItemColor ?? AppTheme.accent;
    final unselectedColor = unselectedItemColor ?? AppTheme.secondaryText;
    
    return Expanded(
      child: Semantics(
        label: '${item.label} tab${isSelected ? ', selected' : ''}',
        button: true,
        selected: isSelected,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: item.onLongPress,
          behavior: HitTestBehavior.opaque,
          child: Tooltip(
            message: item.tooltip ?? item.label,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? selectedColor.withAlpha(26)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.1 : 1.0),
                    child: item.icon is Widget
                        ? item.icon!
                        : CustomIconWidget(
                            iconName: item.iconName ?? 'home',
                            color: isSelected ? selectedColor : unselectedColor,
                            size: isSelected ? 26 : 24,
                          ),
                  ),
                  if (showLabels) ...[
                    SizedBox(height: 0.5.h),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: isSelected ? 11.sp : 10.sp,
                      ) ?? TextStyle(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: isSelected ? 11.sp : 10.sp,
                      ),
                      child: Text(
                        item.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  final String label;
  final String? iconName;
  final Widget? icon;
  final Widget? activeIcon;
  final Color? backgroundColor;
  final String? tooltip;
  final VoidCallback? onLongPress;

  const BottomNavigationItem({
    required this.label,
    this.iconName,
    this.icon,
    this.activeIcon,
    this.backgroundColor,
    this.tooltip,
    this.onLongPress,
  });
}

class CustomFloatingBottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;
  final bool enableHapticFeedback;
  final EdgeInsets? margin;
  final double? borderRadius;

  const CustomFloatingBottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
    this.enableHapticFeedback = true,
    this.margin,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: elevation ?? 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusXl),
        child: CustomBottomNavigationWidget(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          elevation: 0,
          showLabels: showLabels,
          enableHapticFeedback: enableHapticFeedback,
        ),
      ),
    );
  }
}

class CustomTabBarBottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? indicatorColor;
  final double? elevation;
  final bool showLabels;
  final bool enableHapticFeedback;

  const CustomTabBarBottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.indicatorColor,
    this.elevation,
    this.showLabels = true,
    this.enableHapticFeedback = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: elevation ?? 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: showLabels ? 8.h : 7.h,
          child: Column(
            children: [
              // Indicator
              Container(
                height: 3,
                child: Row(
                  children: items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final isSelected = currentIndex == index;
                    
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? (indicatorColor ?? selectedItemColor ?? AppTheme.accent)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Navigation Items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = currentIndex == index;
                    
                    return _buildNavigationItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        if (enableHapticFeedback) {
                          HapticFeedback.lightImpact();
                        }
                        onTap(index);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BottomNavigationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final selectedColor = selectedItemColor ?? AppTheme.accent;
    final unselectedColor = unselectedItemColor ?? AppTheme.secondaryText;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 1.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.1 : 1.0),
                child: item.icon is Widget
                    ? item.icon!
                    : CustomIconWidget(
                        iconName: item.iconName ?? 'home',
                        color: isSelected ? selectedColor : unselectedColor,
                        size: isSelected ? 26 : 24,
                      ),
              ),
              if (showLabels) ...[
                SizedBox(height: 0.5.h),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isSelected ? 11.sp : 10.sp,
                  ) ?? TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontSize: isSelected ? 11.sp : 10.sp,
                  ),
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}