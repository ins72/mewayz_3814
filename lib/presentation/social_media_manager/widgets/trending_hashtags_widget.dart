
import '../../../core/app_export.dart';

class TrendingHashtagsWidget extends StatelessWidget {
  const TrendingHashtagsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trendingHashtags = [
      {
        'hashtag': '#digitalmarketing',
        'growth': '+245%',
        'posts': '2.5M',
        'trend': 'up',
        'category': 'Marketing',
      },
      {
        'hashtag': '#socialmedia',
        'growth': '+180%',
        'posts': '3.2M',
        'trend': 'up',
        'category': 'Social',
      },
      {
        'hashtag': '#contentcreator',
        'growth': '+156%',
        'posts': '1.8M',
        'trend': 'up',
        'category': 'Content',
      },
      {
        'hashtag': '#entrepreneurship',
        'growth': '+134%',
        'posts': '2.1M',
        'trend': 'stable',
        'category': 'Business',
      },
      {
        'hashtag': '#smallbusiness',
        'growth': '+89%',
        'posts': '1.5M',
        'trend': 'up',
        'category': 'Business',
      },
      {
        'hashtag': '#brandstrategy',
        'growth': '+67%',
        'posts': '850K',
        'trend': 'up',
        'category': 'Branding',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppTheme.accent,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Trending Hashtags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  'Live',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4.h),
          
          // Trending hashtags grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 2.5,
            ),
            itemCount: trendingHashtags.length,
            itemBuilder: (context, index) {
              final hashtag = trendingHashtags[index];
              final isPositiveTrend = hashtag['trend'] == 'up';
              
              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isPositiveTrend 
                        ? AppTheme.success.withAlpha(77)
                        : AppTheme.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hashtag and trend indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hashtag['hashtag'] as String,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          isPositiveTrend ? Icons.trending_up : Icons.trending_flat,
                          color: isPositiveTrend ? AppTheme.success : AppTheme.warning,
                          size: 16,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 1.h),
                    
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hashtag['posts'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: isPositiveTrend 
                                ? AppTheme.success.withAlpha(26)
                                : AppTheme.warning.withAlpha(26),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Text(
                            hashtag['growth'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isPositiveTrend ? AppTheme.success : AppTheme.warning,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          
          SizedBox(height: 4.h),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomEnhancedButtonWidget(
                  buttonId: 'research_hashtags',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 16),
                      SizedBox(width: 2.w),
                      const Text('Research'),
                    ],
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hashtag research feature coming soon'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: CustomEnhancedButtonWidget(
                  buttonId: 'save_hashtags',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bookmark_add, size: 16),
                      SizedBox(width: 2.w),
                      const Text('Save Set'),
                    ],
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hashtag set saved successfully'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}