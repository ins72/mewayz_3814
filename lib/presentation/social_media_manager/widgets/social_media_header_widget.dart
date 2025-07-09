import '../../../core/app_export.dart';

class SocialMediaHeaderWidget extends StatelessWidget {
  const SocialMediaHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Social Media Hub',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Manage all platforms',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}