import '../../../core/app_export.dart';

class CompetitorComparisonWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String dateRange;

  const CompetitorComparisonWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Competitor Analysis',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addCompetitor,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCompetitorsList(),
          const SizedBox(height: 16),
          _buildPerformanceComparison(),
        ],
      ),
    );
  }

  Widget _buildCompetitorsList() {
    final competitors = _getCompetitors();
    
    return Column(
      children: competitors.map((competitor) => _buildCompetitorItem(competitor)).toList(),
    );
  }

  Widget _buildCompetitorItem(Map<String, dynamic> competitor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.business,
              color: AppTheme.primaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competitor['name'] as String,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${competitor['followers']} followers',
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildCompetitorMetrics(competitor['metrics'] as Map<String, dynamic>),
          IconButton(
            onPressed: () => _viewCompetitorDetails(competitor),
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.secondaryText,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorMetrics(Map<String, dynamic> metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              metrics['engagementTrend'] == 'up' ? Icons.arrow_upward : Icons.arrow_downward,
              color: metrics['engagementTrend'] == 'up' ? AppTheme.success : AppTheme.error,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              '${metrics['engagement']}%',
              style: TextStyle(
                color: metrics['engagementTrend'] == 'up' ? AppTheme.success : AppTheme.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${metrics['postsPerWeek']} posts/week',
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Comparison',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildComparisonChart(),
      ],
    );
  }

  Widget _buildComparisonChart() {
    final metrics = ['Engagement', 'Reach', 'Followers', 'Posts'];
    final yourData = [85, 72, 90, 65];
    final avgData = [75, 80, 70, 85];

    return Column(
      children: List.generate(metrics.length, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    metrics[index],
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'You: ${yourData[index]}%',
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Avg: ${avgData[index]}%',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: (avgData[index] / 100) * 200,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryText,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: (yourData[index] / 100) * 200,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Map<String, dynamic>> _getCompetitors() {
    return [
      {
        'name': 'Competitor A',
        'followers': '45.2K',
        'metrics': {
          'engagement': 7.8,
          'engagementTrend': 'up',
          'postsPerWeek': 12,
        },
      },
      {
        'name': 'Competitor B',
        'followers': '32.8K',
        'metrics': {
          'engagement': 6.2,
          'engagementTrend': 'down',
          'postsPerWeek': 8,
        },
      },
      {
        'name': 'Competitor C',
        'followers': '58.1K',
        'metrics': {
          'engagement': 9.1,
          'engagementTrend': 'up',
          'postsPerWeek': 15,
        },
      },
    ];
  }

  void _addCompetitor() {
    // Show add competitor dialog
  }

  void _viewCompetitorDetails(Map<String, dynamic> competitor) {
    // View detailed competitor analysis
  }
}