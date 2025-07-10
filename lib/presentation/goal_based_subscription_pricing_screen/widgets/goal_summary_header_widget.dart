import '../../../core/app_export.dart';

class GoalSummaryHeaderWidget extends StatelessWidget {
  final List<String> selectedGoals;
  final Map<String, Map<String, dynamic>> goalData;
  final String recommendedPlan;
  final VoidCallback onBack;

  const GoalSummaryHeaderWidget({
    Key? key,
    required this.selectedGoals,
    required this.goalData,
    required this.recommendedPlan,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back,
                  color: AppTheme.primaryText,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Choose Your Plan',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Goals summary
          Text(
            'Based on your goals:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 12),
          
          // Goal chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedGoals.map((goal) {
              final goalInfo = goalData[goal];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (goalInfo?['color'] as Color?)?.withAlpha(51) ?? AppTheme.accent.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (goalInfo?['color'] as Color?) ?? AppTheme.accent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      goalInfo?['icon'] ?? '🎯',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 6),
                    Text(
                      goal,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: goalInfo?['color'] ?? AppTheme.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          // Recommended plan
          if (recommendedPlan.isNotEmpty) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.success.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: AppTheme.success,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended: $recommendedPlan Plan',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Perfect match for your selected goals',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}