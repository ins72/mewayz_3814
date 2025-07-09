import '../core/app_export.dart';

class CustomEmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? icon;
  final String? iconName;
  final Color? iconColor;
  final double? iconSize;
  final bool showButton;
  final EdgeInsets? padding;
  final CrossAxisAlignment? alignment;

  const CustomEmptyStateWidget({
    Key? key,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.iconName,
    this.iconColor,
    this.iconSize,
    this.showButton = true,
    this.padding,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignment ?? CrossAxisAlignment.center,
        children: [
          // Empty State Icon
          Container(
            width: iconSize ?? 80,
            height: iconSize ?? 80,
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.secondaryText).withAlpha(26),
              borderRadius: BorderRadius.circular((iconSize ?? 80) / 2),
            ),
            child: Center(
              child: icon ??
                  CustomIconWidget(
                    iconName: iconName ?? 'inbox',
                    color: iconColor ?? AppTheme.secondaryText,
                    size: (iconSize ?? 80) * 0.6,
                  ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          // Empty State Title
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          
          if (title != null && message != null) 
            SizedBox(height: AppTheme.spacingM),
          
          // Empty State Message
          if (message != null)
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          
          if (showButton && onButtonPressed != null) ...[
            SizedBox(height: AppTheme.spacingXl),
            
            // Action Button
            ElevatedButton.icon(
              onPressed: onButtonPressed,
              icon: Icon(Icons.add, size: AppTheme.iconSizeM),
              label: Text(buttonText ?? 'Get Started'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomNoDataWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRefresh;

  const CustomNoDataWidget({
    Key? key,
    this.title,
    this.message,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // No Data Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.secondaryText.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.folder_open,
              size: 48,
              color: AppTheme.secondaryText,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title ?? 'No Data Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          Text(
            message ?? 'There is no data to display at the moment.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (onRefresh != null) ...[
            SizedBox(height: AppTheme.spacingXl),
            
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh, size: AppTheme.iconSizeM),
              label: const Text('Refresh'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomNoResultsWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const CustomNoResultsWidget({
    Key? key,
    this.title,
    this.message,
    this.searchQuery,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // No Results Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.secondaryText.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: AppTheme.secondaryText,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title ?? 'No Results Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          Text(
            message ?? 'Try adjusting your search or filters to find what you\'re looking for.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (searchQuery != null) ...[
            SizedBox(height: AppTheme.spacingM),
            
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(
                  color: AppTheme.border.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    size: AppTheme.iconSizeM,
                    color: AppTheme.secondaryText,
                  ),
                  SizedBox(width: AppTheme.spacingS),
                  Text(
                    '"$searchQuery"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (onClearSearch != null) ...[
            SizedBox(height: AppTheme.spacingXl),
            
            TextButton.icon(
              onPressed: onClearSearch,
              icon: Icon(Icons.clear, size: AppTheme.iconSizeM),
              label: const Text('Clear Search'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomOfflineWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const CustomOfflineWidget({
    Key? key,
    this.title,
    this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Offline Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.cloud_off,
              size: 48,
              color: AppTheme.warning,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title ?? 'You\'re Offline',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          Text(
            message ?? 'Please check your internet connection and try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (onRetry != null) ...[
            SizedBox(height: AppTheme.spacingXl),
            
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: AppTheme.iconSizeM),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}