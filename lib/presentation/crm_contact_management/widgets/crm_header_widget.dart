import '../../../core/app_export.dart';

class CrmHeaderWidget extends StatelessWidget {
  const CrmHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CRM Dashboard',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Manage your leads & contacts',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}