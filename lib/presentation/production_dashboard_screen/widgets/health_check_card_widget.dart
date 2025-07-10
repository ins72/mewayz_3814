import 'package:flutter/material.dart';

class HealthCheckCardWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final IconData icon;

  const HealthCheckCardWidget({
    Key? key,
    required this.title,
    required this.data,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errors = data['errors'] as List? ?? [];
    final hasErrors = errors.isNotEmpty;
    
    return Card(
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: hasErrors ? Colors.red : Colors.green,
          size: 28,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: hasErrors 
            ? Text(
                '${errors.length} issues found',
                style: TextStyle(color: Colors.red.shade700),
              )
            : const Text(
                'All checks passed',
                style: TextStyle(color: Colors.green),
              ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show status indicators
                ...data.entries
                    .where((entry) => entry.key != 'errors' && entry.value is bool)
                    .map((entry) => _buildStatusItem(
                          context,
                          entry.key,
                          entry.value as bool,
                        )),
                
                // Show errors if any
                if (hasErrors) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Issues:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...errors.map((error) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16,
                              color: Colors.red.shade600,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                error.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, String key, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: status ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatKey(key),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            status ? 'OK' : 'FAIL',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: status ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}' 
            : '')
        .join(' ');
  }
}