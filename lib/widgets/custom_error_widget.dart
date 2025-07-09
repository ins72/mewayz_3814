import '../core/app_export.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final VoidCallback? onReport;
  final Color? backgroundColor;
  final bool showDetails;

  const CustomErrorWidget({
    Key? key,
    this.errorDetails,
    this.title,
    this.message,
    this.buttonText,
    this.onRetry,
    this.onReport,
    this.backgroundColor,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.error,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          // Error Title
          Text(
            title ?? 'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Error Message
          Text(
            message ?? 'An unexpected error occurred. Please try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (showDetails && errorDetails != null) ...[
            SizedBox(height: AppTheme.spacingL),
            
            // Error Details (Expandable)
            ExpansionTile(
              title: Text(
                'Error Details',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              iconColor: AppTheme.secondaryText,
              collapsedIconColor: AppTheme.secondaryText,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    border: Border.all(
                      color: AppTheme.border.withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    errorDetails!.exception.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                      fontFamily: 'monospace',
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          SizedBox(height: AppTheme.spacingXl),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onRetry != null) ...[
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh, size: AppTheme.iconSizeM),
                  label: Text(buttonText ?? 'Try Again'),
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
                
                if (onReport != null) SizedBox(width: AppTheme.spacingM),
              ],
              
              if (onReport != null)
                OutlinedButton.icon(
                  onPressed: onReport,
                  icon: Icon(Icons.bug_report, size: AppTheme.iconSizeM),
                  label: const Text('Report Issue'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondaryText,
                    side: BorderSide(
                      color: AppTheme.border,
                      width: 1.5,
                    ),
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
          ),
        ],
      ),
    );
  }
}

class CustomNetworkErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const CustomNetworkErrorWidget({
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
          // Network Error Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.wifi_off,
              size: 48,
              color: AppTheme.warning,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title ?? 'No Internet Connection',
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

class CustomTimeoutErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const CustomTimeoutErrorWidget({
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
          // Timeout Error Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(26),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.hourglass_empty,
              size: 48,
              color: AppTheme.error,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          Text(
            title ?? 'Request Timeout',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          Text(
            message ?? 'The request took too long to complete. Please try again.',
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