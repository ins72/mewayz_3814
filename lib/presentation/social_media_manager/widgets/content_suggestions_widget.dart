
import '../../../core/app_export.dart';

class ContentSuggestionsWidget extends StatelessWidget {
  const ContentSuggestionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      {
        'title': 'Behind the Scenes',
        'description': 'Show your team at work',
        'icon': Icons.camera_alt,
        'color': AppTheme.success,
        'engagement': 'High',
      },
      {
        'title': 'Product Showcase',
        'description': 'Feature your latest products',
        'icon': Icons.star,
        'color': AppTheme.warning,
        'engagement': 'Medium',
      },
      {
        'title': 'Customer Story',
        'description': 'Share testimonials',
        'icon': Icons.person,
        'color': AppTheme.accent,
        'engagement': 'High',
      },
      {
        'title': 'Educational Content',
        'description': 'Share tips and tutorials',
        'icon': Icons.school,
        'color': AppTheme.error,
        'engagement': 'Medium',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.success,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Content Suggestions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Column(
            children: suggestions.map((suggestion) {
              return Container(
                margin: EdgeInsets.only(bottom: 3.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: (suggestion['color'] as Color).withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        suggestion['icon'] as IconData,
                        color: suggestion['color'] as Color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['title'] as String,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            suggestion['description'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: suggestion['engagement'] == 'High'
                                ? AppTheme.success.withAlpha(26)
                                : AppTheme.warning.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            suggestion['engagement'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: suggestion['engagement'] == 'High'
                                  ? AppTheme.success
                                  : AppTheme.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.secondaryText,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}