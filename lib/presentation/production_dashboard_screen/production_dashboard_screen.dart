import '../../core/app_export.dart';
import '../../core/environment_config.dart';
import '../../services/production_data_validation_service.dart';
import './widgets/health_check_card_widget.dart';
import './widgets/production_metrics_widget.dart';
import './widgets/system_status_widget.dart';

/// Production monitoring dashboard for administrators
class ProductionDashboardScreen extends StatefulWidget {
  const ProductionDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ProductionDashboardScreen> createState() => _ProductionDashboardScreenState();
}

class _ProductionDashboardScreenState extends State<ProductionDashboardScreen> {
  final ProductionDataValidationService _validationService = ProductionDataValidationService();
  
  bool _isLoading = true;
  Map<String, dynamic> _healthStatus = {};
  Map<String, dynamic> _productionMetrics = {};
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() => _isLoading = true);
      
      await _validationService.initialize();
      await _loadHealthStatus();
      await _loadProductionMetrics();
      
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize production dashboard: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadHealthStatus() async {
    try {
      final status = await _validationService.runProductionReadinessCheck();
      setState(() => _healthStatus = status);
    } catch (e) {
      ErrorHandler.handleError('Failed to load health status: $e');
    }
  }

  Future<void> _loadProductionMetrics() async {
    try {
      // Get production metrics from various services
      final supabaseService = SupabaseService.instance;
      final client = await supabaseService.client;
      
      // Get basic system metrics
      final userCount = await client.from('user_profiles').select('id');
      final workspaceCount = await client.from('workspaces').select('id');
      final analyticsCount = await client.from('analytics_events').select('id');
      
      setState(() {
        _productionMetrics = {
          'total_users': userCount.length ?? 0,
          'total_workspaces': workspaceCount.length ?? 0,
          'total_events': analyticsCount.length ?? 0,
          'database_size': 'N/A',
          'uptime': '99.9%',
          'last_updated': DateTime.now().toIso8601String(),
        };
      });
    } catch (e) {
      ErrorHandler.handleError('Failed to load production metrics: $e');
    }
  }

  Future<void> _runHealthCheck() async {
    await _loadHealthStatus();
    
    if (!mounted) return;
    
    final score = _healthStatus['readiness_score'] ?? 0;
    final status = _healthStatus['overall_status'] ?? 'unknown';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Health Check Complete: $status ($score%)'),
        backgroundColor: score >= 90 ? Colors.green : 
                        score >= 70 ? Colors.orange : Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Production Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData),
          IconButton(
            icon: const Icon(Icons.health_and_safety),
            onPressed: _runHealthCheck),
        ]),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Status Overview
                    SystemStatusWidget(
                      healthStatus: _healthStatus,
                      onHealthCheck: _runHealthCheck),
                    
                    const SizedBox(height: 24),
                    
                    // Health Check Cards
                    HealthCheckCardWidget(
                      title: 'Database Health',
                      data: _healthStatus['database_health'] ?? {},
                      icon: Icons.storage),
                    
                    const SizedBox(height: 16),
                    
                    HealthCheckCardWidget(
                      title: 'Authentication Flow',
                      data: _healthStatus['authentication_flow'] ?? {},
                      icon: Icons.security),
                    
                    const SizedBox(height: 16),
                    
                    HealthCheckCardWidget(
                      title: 'Data Consistency',
                      data: _healthStatus['data_consistency'] ?? {},
                      icon: Icons.verified),
                    
                    const SizedBox(height: 16),
                    
                    HealthCheckCardWidget(
                      title: 'Real-time Connections',
                      data: _healthStatus['realtime_connections'] ?? {},
                      icon: Icons.wifi),
                    
                    const SizedBox(height: 24),
                    
                    // Production Metrics
                    ProductionMetricsWidget(
                      metrics: _productionMetrics),
                    
                    const SizedBox(height: 24),
                    
                    // Environment Information
                    _buildEnvironmentInfo(),
                  ]))));
  }

  Widget _buildEnvironmentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Environment Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
              ]),
            const SizedBox(height: 16),
            _buildInfoRow('Environment', EnvironmentConfig.environment),
            _buildInfoRow('Production Ready', EnvironmentConfig.isProductionReady.toString()),
            _buildInfoRow('App Version', ProductionConfig.appVersion),
            _buildInfoRow('Build Number', ProductionConfig.buildNumber),
            _buildInfoRow('Platform', EnvironmentConfig.platform),
            _buildInfoRow('Base URL', ProductionConfig.baseUrl),
          ])));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end)),
        ]));
  }
}