import '../../../core/app_export.dart';

class DomainStatusHeaderWidget extends StatelessWidget {
  final List<Map<String, dynamic>> domains;
  final Function(Map<String, dynamic>) onDomainSelect;

  const DomainStatusHeaderWidget({
    Key? key,
    required this.domains,
    required this.onDomainSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectedDomains = domains.where((d) => d['status'] == 'connected').length;
    final totalDomains = domains.length;
    final healthPercentage = totalDomains > 0 ? (connectedDomains / totalDomains) : 0.0;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Color(0xFF101010),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Connection Health Indicator
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: _getHealthColor(healthPercentage).withAlpha(26),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  _getHealthIcon(healthPercentage),
                  color: _getHealthColor(healthPercentage),
                  size: 20,
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domain Health',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingXs),
                    Text(
                      '$connectedDomains of $totalDomains domains connected',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: _getHealthColor(healthPercentage).withAlpha(26),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Text(
                  '${(healthPercentage * 100).toInt()}%',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: _getHealthColor(healthPercentage),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          if (totalDomains > 0) ...[
            SizedBox(height: AppTheme.spacingM),
            
            // Health Progress Bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: healthPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getHealthColor(healthPercentage),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: AppTheme.spacingM),
            
            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Connected',
                    connectedDomains.toString(),
                    AppTheme.success,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.border,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    domains.where((d) => d['status'] == 'pending').length.toString(),
                    AppTheme.warning,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.border,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Errors',
                    domains.where((d) => d['status'] == 'error').length.toString(),
                    AppTheme.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppTheme.spacingXs),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }

  Color _getHealthColor(double percentage) {
    if (percentage >= 0.8) return AppTheme.success;
    if (percentage >= 0.5) return AppTheme.warning;
    return AppTheme.error;
  }

  IconData _getHealthIcon(double percentage) {
    if (percentage >= 0.8) return Icons.check_circle;
    if (percentage >= 0.5) return Icons.warning;
    return Icons.error;
  }
}