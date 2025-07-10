import 'package:flutter/material.dart';

class SystemStatusWidget extends StatelessWidget {
  final Map<String, dynamic> healthStatus;
  final VoidCallback onHealthCheck;

  const SystemStatusWidget({
    Key? key,
    required this.healthStatus,
    required this.onHealthCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = healthStatus['readiness_score'] ?? 0;
    final status = healthStatus['overall_status'] ?? 'unknown';
    
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (status) {
      case 'production_ready':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Production Ready';
        break;
      case 'mostly_ready':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = 'Mostly Ready';
        break;
      case 'needs_work':
        statusColor = Colors.orange.shade700;
        statusIcon = Icons.build;
        statusText = 'Needs Work';
        break;
      case 'not_ready':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Not Ready';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  statusIcon,
                  size: 32,
                  color: statusColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Status',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onHealthCheck,
                  icon: const Icon(Icons.health_and_safety, size: 18),
                  label: const Text('Check Health'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Readiness Score
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Readiness Score',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: score / 100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$score%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            
            if (healthStatus['timestamp'] != null) ...[
              const SizedBox(height: 12),
              Text(
                'Last checked: ${_formatTimestamp(healthStatus['timestamp'])}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}