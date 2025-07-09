import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TemplateAnalyticsWidget extends StatefulWidget {
  final String templateId;

  const TemplateAnalyticsWidget({
    Key? key,
    required this.templateId,
  }) : super(key: key);

  @override
  State<TemplateAnalyticsWidget> createState() => _TemplateAnalyticsWidgetState();
}

class _TemplateAnalyticsWidgetState extends State<TemplateAnalyticsWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppTheme.secondaryText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Template Analytics',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Usage stats
                  _buildSection(
                    title: 'Usage Statistics',
                    child: Column(
                      children: [
                        _buildStatCard('Total Downloads', '1,250', Icons.download, AppTheme.accent),
                        const SizedBox(height: 12),
                        _buildStatCard('Active Users', '890', Icons.people, AppTheme.success),
                        const SizedBox(height: 12),
                        _buildStatCard('Average Rating', '4.8', Icons.star, AppTheme.warning),
                        const SizedBox(height: 12),
                        _buildStatCard('Conversion Rate', '12.5%', Icons.trending_up, AppTheme.accent),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Performance metrics
                  _buildSection(
                    title: 'Performance Metrics',
                    child: Column(
                      children: [
                        _buildMetricRow('Click-through Rate', '8.2%', '+2.1%'),
                        const SizedBox(height: 12),
                        _buildMetricRow('Bounce Rate', '35.4%', '-1.8%'),
                        const SizedBox(height: 12),
                        _buildMetricRow('Session Duration', '3m 45s', '+15s'),
                        const SizedBox(height: 12),
                        _buildMetricRow('Mobile Usage', '78%', '+5%'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recent reviews
                  _buildSection(
                    title: 'Recent Reviews',
                    child: Column(
                      children: [
                        _buildReviewCard('Sarah Johnson', 5, 'Amazing template! Easy to customize and looks professional.', '2 hours ago'),
                        const SizedBox(height: 12),
                        _buildReviewCard('Mike Chen', 4, 'Great design but could use more color options.', '1 day ago'),
                        const SizedBox(height: 12),
                        _buildReviewCard('Emma Wilson', 5, 'Perfect for my business needs. Highly recommend!', '3 days ago'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Industry comparison
                  _buildSection(
                    title: 'Industry Comparison',
                    child: Column(
                      children: [
                        _buildComparisonRow('Downloads', '1,250', '890', 'Above Average'),
                        const SizedBox(height: 12),
                        _buildComparisonRow('Rating', '4.8', '4.3', 'Excellent'),
                        const SizedBox(height: 12),
                        _buildComparisonRow('Conversion', '12.5%', '8.7%', 'Above Average'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, String change) {
    final isPositive = change.startsWith('+');
    final changeColor = isPositive ? AppTheme.success : AppTheme.error;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryText,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: changeColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: changeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, int rating, String comment, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.accent,
                child: Text(
                  name[0],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: AppTheme.warning,
                          size: 16,
                        )),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String metric, String thisTemplate, String industry, String performance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metric,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                thisTemplate,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'vs $industry',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(26),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              performance,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}