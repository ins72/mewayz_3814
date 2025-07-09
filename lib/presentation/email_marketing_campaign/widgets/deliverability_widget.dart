
import '../../../core/app_export.dart';

class DeliverabilityWidget extends StatefulWidget {
  const DeliverabilityWidget({Key? key}) : super(key: key);

  @override
  State<DeliverabilityWidget> createState() => _DeliverabilityWidgetState();
}

class _DeliverabilityWidgetState extends State<DeliverabilityWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.security_outlined,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Deliverability Tools',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildDeliverabilityScore(),
        SizedBox(height: 16.h),
        _buildAuthenticationStatus(),
        SizedBox(height: 16.h),
        _buildReputationMonitoring(),
        SizedBox(height: 16.h),
        _buildSpamTesting(),
      ],
    );
  }

  Widget _buildDeliverabilityScore() {
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
          Text(
            'Deliverability Score',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '87',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.success,
                              ),
                    ),
                    Text(
                      'Overall Score',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.success,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '87%',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.success,
                                ),
                      ),
                      Text(
                        'Excellent',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.success,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildScoreItem('Reputation', '92', AppTheme.success),
              ),
              Expanded(
                child:
                    _buildScoreItem('Authentication', '95', AppTheme.success),
              ),
              Expanded(
                child: _buildScoreItem('Content', '78', AppTheme.warning),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String score, Color color) {
    return Column(
      children: [
        Text(
          score,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildAuthenticationStatus() {
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
          Text(
            'Authentication Status',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 16.h),
          _buildAuthItem('SPF Record', true, 'Configured and valid'),
          _buildAuthItem('DKIM Signature', true, 'Active and signing'),
          _buildAuthItem('DMARC Policy', false, 'Not configured'),
          _buildAuthItem('Return Path', true, 'Properly aligned'),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: _configureAuthentication,
            icon: const Icon(Icons.settings_outlined),
            label: const Text('Configure Authentication'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthItem(String name, bool isConfigured, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isConfigured ? Icons.check_circle_rounded : Icons.warning_rounded,
            color: isConfigured ? AppTheme.success : AppTheme.warning,
            size: 20,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReputationMonitoring() {
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
              Text(
                'Reputation Monitoring',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _viewFullReport,
                child: const Text('View Report'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildReputationItem('Gmail', '95%', AppTheme.success),
              ),
              Expanded(
                child: _buildReputationItem('Outlook', '92%', AppTheme.success),
              ),
              Expanded(
                child: _buildReputationItem('Yahoo', '87%', AppTheme.warning),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.accent,
                  size: 16,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Your sender reputation is good across all major providers',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReputationItem(String provider, String score, Color color) {
    return Column(
      children: [
        Text(
          score,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
        Text(
          provider,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildSpamTesting() {
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
          Text(
            'Spam Testing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppTheme.success,
                      size: 16,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Spam Score: 2.1/10',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.success,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'GOOD',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your email is unlikely to be marked as spam',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _testSpamScore,
                  icon: const Icon(Icons.bug_report_outlined),
                  label: const Text('Test Spam Score'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _viewSpamReport,
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('View Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _configureAuthentication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Setup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Follow these steps to configure email authentication:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.h),
            Text(
              '1. Set up SPF record in DNS\n2. Configure DKIM signing\n3. Implement DMARC policy\n4. Verify return path alignment',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to authentication setup
            },
            child: const Text('Setup Guide'),
          ),
        ],
      ),
    );
  }

  void _viewFullReport() {
    // Navigate to full reputation report
  }

  void _testSpamScore() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Spam test initiated. Results will be available shortly.'),
      ),
    );
  }

  void _viewSpamReport() {
    // Navigate to detailed spam report
  }
}