
import '../../../core/app_export.dart';

class CrmAnalyticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> contacts;
  final List<Map<String, dynamic>> stages;

  const CrmAnalyticsWidget({
    Key? key,
    required this.contacts,
    required this.stages,
  }) : super(key: key);

  @override
  State<CrmAnalyticsWidget> createState() => _CrmAnalyticsWidgetState();
}

class _CrmAnalyticsWidgetState extends State<CrmAnalyticsWidget> {
  String _selectedPeriod = 'This Month';
  final List<String> _periodOptions = ['This Week', 'This Month', 'This Quarter', 'This Year'];

  @override
  Widget build(BuildContext context) {
    final analytics = _calculateAnalytics();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with period selector
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'CRM Analytics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border.withAlpha(77)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    dropdownColor: AppTheme.surface,
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                    items: _periodOptions.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(
                          period,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Key metrics cards
          _buildMetricsGrid(analytics),
          
          SizedBox(height: 3.h),
          
          // Pipeline analysis
          _buildPipelineAnalysis(analytics),
          
          SizedBox(height: 3.h),
          
          // Lead score distribution
          _buildLeadScoreDistribution(analytics),
          
          SizedBox(height: 3.h),
          
          // Conversion funnel
          _buildConversionFunnel(analytics),
          
          SizedBox(height: 3.h),
          
          // Performance by source
          _buildSourcePerformance(analytics),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> analytics) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'Total Contacts',
          '${analytics['totalContacts']}',
          Icons.people,
          AppTheme.accent,
          '+12%',
        ),
        _buildMetricCard(
          'Pipeline Value',
          '\$${_formatNumber(analytics['pipelineValue'])}',
          Icons.attach_money,
          AppTheme.success,
          '+8%',
        ),
        _buildMetricCard(
          'Conversion Rate',
          '${analytics['conversionRate']}%',
          Icons.trending_up,
          AppTheme.warning,
          '+3%',
        ),
        _buildMetricCard(
          'Avg Lead Score',
          '${analytics['avgLeadScore']}',
          Icons.star,
          AppTheme.error,
          '-2%',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                change,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: change.startsWith('+') ? AppTheme.success : AppTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineAnalysis(Map<String, dynamic> analytics) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pipeline Analysis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Pipeline stages
          ...widget.stages.map((stage) {
            final stageContacts = widget.contacts
                .where((contact) => contact['stage'] == stage['name'])
                .toList();
            final percentage = widget.contacts.isEmpty 
                ? 0.0 
                : (stageContacts.length / widget.contacts.length) * 100;
            
            return _buildPipelineStageBar(
              stage['name'],
              stageContacts.length,
              percentage,
              stage['color'] as Color,
              stage['value'],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPipelineStageBar(
    String stageName,
    int count,
    double percentage,
    Color color,
    dynamic value,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  stageName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$count (${percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '\$${_formatNumber(value)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildLeadScoreDistribution(Map<String, dynamic> analytics) {
    final distribution = analytics['leadScoreDistribution'] as Map<String, int>;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Score Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Score ranges
          ...distribution.entries.map((entry) {
            final percentage = widget.contacts.isEmpty 
                ? 0.0 
                : (entry.value / widget.contacts.length) * 100;
            
            return _buildScoreRangeBar(
              entry.key,
              entry.value,
              percentage,
              _getScoreColor(entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildScoreRangeBar(
    String range,
    int count,
    double percentage,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  range,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                '$count contacts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildConversionFunnel(Map<String, dynamic> analytics) {
    final funnel = analytics['conversionFunnel'] as List<Map<String, dynamic>>;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Funnel',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Funnel stages
          ...funnel.map((stage) {
            final index = funnel.indexOf(stage);
            final isLast = index == funnel.length - 1;
            
            return _buildFunnelStage(
              stage['name'],
              stage['count'],
              stage['percentage'],
              stage['color'] as Color,
              isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFunnelStage(
    String stageName,
    int count,
    double percentage,
    Color color,
    bool isLast,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withAlpha(77)),
          ),
          child: Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  stageName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        
        if (!isLast) ...[
          SizedBox(height: 1.h),
          Center(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ],
    );
  }

  Widget _buildSourcePerformance(Map<String, dynamic> analytics) {
    final sources = analytics['sourcePerformance'] as Map<String, Map<String, dynamic>>;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance by Source',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Source performance list
          ...sources.entries.map((entry) {
            final sourceName = entry.key;
            final sourceData = entry.value;
            
            return _buildSourcePerformanceCard(
              sourceName,
              sourceData['contacts'] as int,
              sourceData['value'] as double,
              sourceData['conversionRate'] as double,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSourcePerformanceCard(
    String sourceName,
    int contacts,
    double value,
    double conversionRate,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getSourceIcon(sourceName),
                  color: AppTheme.accent,
                  size: 16,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  sourceName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${conversionRate.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                '$contacts contacts',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                '\$${_formatNumber(value)} value',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateAnalytics() {
    final totalContacts = widget.contacts.length;
    final pipelineValue = widget.contacts.fold<double>(
      0,
      (sum, contact) => sum + (contact['value'] as num? ?? 0).toDouble(),
    );
    
    final avgLeadScore = widget.contacts.isEmpty
        ? 0.0
        : widget.contacts.fold<double>(
            0,
            (sum, contact) => sum + (contact['leadScore'] as num? ?? 0).toDouble(),
          ) / totalContacts;
    
    final conversionRate = widget.contacts.isEmpty
        ? 0.0
        : (widget.contacts.where((c) => c['stage'] == 'Closed Won').length / totalContacts) * 100;
    
    // Lead score distribution
    final leadScoreDistribution = <String, int>{};
    for (final contact in widget.contacts) {
      final score = contact['leadScore'] as num? ?? 0;
      String range;
      if (score >= 80) {
        range = '80-100';
      } else if (score >= 60) {
        range = '60-79';
      } else if (score >= 40) {
        range = '40-59';
      } else {
        range = '0-39';
      }
      leadScoreDistribution[range] = (leadScoreDistribution[range] ?? 0) + 1;
    }
    
    // Conversion funnel
    final conversionFunnel = widget.stages.map((stage) {
      final stageContacts = widget.contacts.where((c) => c['stage'] == stage['name']).length;
      final percentage = totalContacts == 0 ? 0.0 : (stageContacts / totalContacts) * 100;
      
      return {
        'name': stage['name'],
        'count': stageContacts,
        'percentage': percentage,
        'color': stage['color'],
      };
    }).toList();
    
    // Source performance
    final sourcePerformance = <String, Map<String, dynamic>>{};
    final sourceGroups = <String, List<Map<String, dynamic>>>{};
    
    for (final contact in widget.contacts) {
      final source = contact['source'] as String? ?? 'Unknown';
      sourceGroups[source] = (sourceGroups[source] ?? [])..add(contact);
    }
    
    for (final entry in sourceGroups.entries) {
      final sourceName = entry.key;
      final sourceContacts = entry.value;
      final sourceValue = sourceContacts.fold<double>(
        0,
        (sum, contact) => sum + (contact['value'] as num? ?? 0).toDouble(),
      );
      final sourceConversionRate = sourceContacts.isEmpty
          ? 0.0
          : (sourceContacts.where((c) => c['stage'] == 'Closed Won').length / sourceContacts.length) * 100;
      
      sourcePerformance[sourceName] = {
        'contacts': sourceContacts.length,
        'value': sourceValue,
        'conversionRate': sourceConversionRate,
      };
    }
    
    return {
      'totalContacts': totalContacts,
      'pipelineValue': pipelineValue,
      'avgLeadScore': avgLeadScore.toInt(),
      'conversionRate': conversionRate.toInt(),
      'leadScoreDistribution': leadScoreDistribution,
      'conversionFunnel': conversionFunnel,
      'sourcePerformance': sourcePerformance,
    };
  }

  Color _getScoreColor(String range) {
    switch (range) {
      case '80-100':
        return AppTheme.success;
      case '60-79':
        return AppTheme.warning;
      case '40-59':
        return AppTheme.accent;
      case '0-39':
        return AppTheme.error;
      default:
        return AppTheme.secondaryText;
    }
  }

  IconData _getSourceIcon(String source) {
    switch (source.toLowerCase()) {
      case 'linkedin':
        return Icons.business;
      case 'website':
        return Icons.web;
      case 'email':
        return Icons.email;
      case 'referral':
        return Icons.person_add;
      default:
        return Icons.source;
    }
  }

  String _formatNumber(dynamic value) {
    if (value is! num) return '0';
    
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}