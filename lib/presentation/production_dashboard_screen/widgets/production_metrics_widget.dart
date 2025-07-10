import 'package:flutter/material.dart';

class ProductionMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const ProductionMetricsWidget({
    Key? key,
    required this.metrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Production Metrics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
              ]),
            const SizedBox(height: 16),
            
            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildMetricCard(
                  context,
                  'Total Users',
                  metrics['total_users']?.toString() ?? '0',
                  Icons.people,
                  Colors.blue),
                _buildMetricCard(
                  context,
                  'Workspaces',
                  metrics['total_workspaces']?.toString() ?? '0',
                  Icons.business,
                  Colors.green),
                _buildMetricCard(
                  context,
                  'Analytics Events',
                  metrics['total_events']?.toString() ?? '0',
                  Icons.track_changes,
                  Colors.orange),
                _buildMetricCard(
                  context,
                  'Uptime',
                  metrics['uptime']?.toString() ?? 'N/A',
                  Icons.schedule,
                  Colors.purple),
              ]),
            
            if (metrics['last_updated'] != null) ...[
              const SizedBox(height: 12),
              Text(
                'Last updated: ${_formatTimestamp(metrics['last_updated'])}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600)),
            ],
          ])));
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withAlpha(77)),
        borderRadius: BorderRadius.circular(8),
        color: color.withAlpha(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis)),
            ]),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        ]));
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