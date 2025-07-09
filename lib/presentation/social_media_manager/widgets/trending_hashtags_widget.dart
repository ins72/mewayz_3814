
import '../../../core/app_export.dart';

class TrendingHashtagsWidget extends StatelessWidget {
  const TrendingHashtagsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hashtags = [
      '#socialmedia',
      '#digitalmarketing',
      '#trending',
      '#viral',
      '#engagement',
      '#content',
      '#marketing',
      '#brand',
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
                  color: AppTheme.warning.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tag,
                  color: AppTheme.warning,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Trending Hashtags',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 2.h,
            children: hashtags.map((hashtag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hashtag,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.trending_up,
                      color: AppTheme.warning,
                      size: 14,
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