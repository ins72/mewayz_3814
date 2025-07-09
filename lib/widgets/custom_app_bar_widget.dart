
import '../core/app_export.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Widget? titleWidget;
  final bool showBottomBorder;

  const CustomAppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.titleWidget,
    this.showBottomBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryBackground,
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.divider,
                  width: 1,
                ),
              )
            : null,
      ),
      child: AppBar(
        backgroundColor: backgroundColor ?? AppTheme.primaryBackground,
        foregroundColor: foregroundColor ?? AppTheme.primaryText,
        elevation: elevation ?? 0,
        centerTitle: centerTitle,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: leading ??
            (showBackButton
                ? IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: foregroundColor ?? AppTheme.primaryText,
                      size: 24,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  )
                : null),
        title: titleWidget ??
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: foregroundColor ?? AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
        actions: actions?.map((action) => Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: action,
        )).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(8.h);
}

class CustomSliverAppBarWidget extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Widget? titleWidget;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;

  const CustomSliverAppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.titleWidget,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor ?? AppTheme.primaryBackground,
      foregroundColor: foregroundColor ?? AppTheme.primaryText,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      pinned: pinned,
      floating: floating,
      snap: snap,
      expandedHeight: expandedHeight,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: foregroundColor ?? AppTheme.primaryText,
                    size: 24,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      title: titleWidget ??
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: foregroundColor ?? AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
      actions: actions?.map((action) => Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: action,
      )).toList(),
      flexibleSpace: flexibleSpace,
    );
  }
}