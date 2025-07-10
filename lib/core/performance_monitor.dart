import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

/// Performance categories
enum PerformanceCategory {
  network,
  database,
  ui,
  computation,
  io,
  cache,
}

/// Performance metric data structure
class PerformanceMetric {
  final String operationId;
  final String operationName;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final PerformanceCategory category;

  PerformanceMetric({
    required this.operationId,
    required this.operationName,
    required this.duration,
    required this.timestamp,
    this.metadata = const {},
    required this.category,
  });

  double get durationMs => duration.inMicroseconds / 1000.0;
}

/// Memory usage information
class MemoryInfo {
  final int totalMemory;
  final int usedMemory;
  final int freeMemory;
  final double usagePercentage;

  MemoryInfo({
    required this.totalMemory,
    required this.usedMemory,
    required this.freeMemory,
    required this.usagePercentage,
  });
}

/// Performance monitoring and optimization service
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _activeOperations = {};
  final Queue<PerformanceMetric> _metrics = Queue<PerformanceMetric>();
  final Map<String, double> _averageMetrics = {};
  final Map<String, int> _operationCounts = {};
  final StreamController<PerformanceMetric> _metricsStreamController = 
      StreamController<PerformanceMetric>.broadcast();

  static const int _maxMetricsHistory = 1000;
  static const Duration _cleanupInterval = Duration(minutes: 5);

  Timer? _cleanupTimer;
  Timer? _memoryCheckTimer;

  /// Initialize performance monitoring
  void initialize() {
    _startCleanupTimer();
    _startMemoryMonitoring();
    debugPrint('Performance monitoring initialized');
  }

  /// Start a performance measurement
  void startOperation(String operationName, {
    String? customId,
    PerformanceCategory category = PerformanceCategory.computation,
    Map<String, dynamic>? metadata,
  }) {
    final operationId = customId ?? _generateOperationId(operationName);
    final stopwatch = Stopwatch()..start();
    
    _activeOperations[operationId] = stopwatch;
    
    // Track operation start
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    
    if (kDebugMode) {
      debugPrint('Performance: Started operation "$operationName" (ID: $operationId)');
    }
  }

  /// End a performance measurement
  void endOperation(String operationName, {
    String? customId,
    PerformanceCategory category = PerformanceCategory.computation,
    Map<String, dynamic>? metadata,
  }) {
    final operationId = customId ?? _generateOperationId(operationName);
    final stopwatch = _activeOperations.remove(operationId);
    
    if (stopwatch == null) {
      debugPrint('Performance: Warning - No active operation found for "$operationName" (ID: $operationId)');
      return;
    }

    stopwatch.stop();
    
    final metric = PerformanceMetric(
      operationId: operationId,
      operationName: operationName,
      duration: stopwatch.elapsed,
      timestamp: DateTime.now(),
      metadata: metadata ?? {},
      category: category);

    _recordMetric(metric);
    
    if (kDebugMode) {
      debugPrint('Performance: Completed operation "$operationName" in ${metric.durationMs.toStringAsFixed(2)}ms');
    }
  }

  /// Measure a function execution time
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    PerformanceCategory category = PerformanceCategory.computation,
    Map<String, dynamic>? metadata,
  }) async {
    final operationId = _generateOperationId(operationName);
    startOperation(operationName, customId: operationId, category: category, metadata: metadata);
    
    try {
      final result = await operation();
      endOperation(operationName, customId: operationId, category: category, metadata: metadata);
      return result;
    } catch (e) {
      endOperation(operationName, customId: operationId, category: category, metadata: {
        ...?metadata,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Measure a synchronous function execution time
  T measureSync<T>(
    String operationName,
    T Function() operation, {
    PerformanceCategory category = PerformanceCategory.computation,
    Map<String, dynamic>? metadata,
  }) {
    final operationId = _generateOperationId(operationName);
    startOperation(operationName, customId: operationId, category: category, metadata: metadata);
    
    try {
      final result = operation();
      endOperation(operationName, customId: operationId, category: category, metadata: metadata);
      return result;
    } catch (e) {
      endOperation(operationName, customId: operationId, category: category, metadata: {
        ...?metadata,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Record a performance metric
  void _recordMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    _metricsStreamController.add(metric);
    
    // Update average
    final operationName = metric.operationName;
    final currentAverage = _averageMetrics[operationName] ?? 0.0;
    final operationCount = _operationCounts[operationName] ?? 1;
    
    _averageMetrics[operationName] = ((currentAverage * (operationCount - 1)) + metric.durationMs) / operationCount;
    
    // Maintain history limit
    if (_metrics.length > _maxMetricsHistory) {
      _metrics.removeFirst();
    }
    
    // Alert for slow operations
    _checkForSlowOperations(metric);
  }

  /// Check for slow operations and alert
  void _checkForSlowOperations(PerformanceMetric metric) {
    final Map<PerformanceCategory, double> thresholds = {
      PerformanceCategory.network: 5000.0, // 5 seconds
      PerformanceCategory.database: 2000.0, // 2 seconds
      PerformanceCategory.ui: 16.0, // 16ms (60fps)
      PerformanceCategory.computation: 100.0, // 100ms
      PerformanceCategory.io: 1000.0, // 1 second
      PerformanceCategory.cache: 50.0, // 50ms
    };

    final threshold = thresholds[metric.category] ?? 100.0;
    
    if (metric.durationMs > threshold) {
      debugPrint('Performance: WARNING - Slow operation detected!');
      debugPrint('  Operation: ${metric.operationName}');
      debugPrint('  Duration: ${metric.durationMs.toStringAsFixed(2)}ms');
      debugPrint('  Threshold: ${threshold.toStringAsFixed(2)}ms');
      debugPrint('  Category: ${metric.category.name}');
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    
    final recentMetrics = _metrics
        .where((metric) => metric.timestamp.isAfter(last24Hours))
        .toList();

    final statsByCategory = <String, Map<String, dynamic>>{};
    final statsByOperation = <String, Map<String, dynamic>>{};

    for (final metric in recentMetrics) {
      // Stats by category
      final categoryName = metric.category.name;
      if (!statsByCategory.containsKey(categoryName)) {
        statsByCategory[categoryName] = {
          'count': 0,
          'totalDuration': 0.0,
          'minDuration': double.infinity,
          'maxDuration': 0.0,
        };
      }
      
      final categoryStats = statsByCategory[categoryName]!;
      categoryStats['count'] = categoryStats['count'] + 1;
      categoryStats['totalDuration'] = categoryStats['totalDuration'] + metric.durationMs;
      categoryStats['minDuration'] = math.min(categoryStats['minDuration'] as double, metric.durationMs);
      categoryStats['maxDuration'] = math.max(categoryStats['maxDuration'] as double, metric.durationMs);

      // Stats by operation
      final operationName = metric.operationName;
      if (!statsByOperation.containsKey(operationName)) {
        statsByOperation[operationName] = {
          'count': 0,
          'totalDuration': 0.0,
          'minDuration': double.infinity,
          'maxDuration': 0.0,
        };
      }
      
      final operationStats = statsByOperation[operationName]!;
      operationStats['count'] = operationStats['count'] + 1;
      operationStats['totalDuration'] = operationStats['totalDuration'] + metric.durationMs;
      operationStats['minDuration'] = math.min(operationStats['minDuration'] as double, metric.durationMs);
      operationStats['maxDuration'] = math.max(operationStats['maxDuration'] as double, metric.durationMs);
    }

    // Calculate averages
    statsByCategory.forEach((category, stats) {
      stats['averageDuration'] = stats['totalDuration'] / stats['count'];
    });

    statsByOperation.forEach((operation, stats) {
      stats['averageDuration'] = stats['totalDuration'] / stats['count'];
    });

    return {
      'summary': {
        'total_operations_24h': recentMetrics.length,
        'active_operations': _activeOperations.length,
        'average_operation_time': recentMetrics.isEmpty ? 0.0 : 
            recentMetrics.fold(0.0, (sum, metric) => sum + metric.durationMs) / recentMetrics.length,
      },
      'by_category': statsByCategory,
      'by_operation': statsByOperation,
      'slowest_operations': _getSlowestOperations(recentMetrics),
    };
  }

  /// Get slowest operations
  List<Map<String, dynamic>> _getSlowestOperations(List<PerformanceMetric> metrics) {
    final sortedMetrics = metrics.toList()
      ..sort((a, b) => b.durationMs.compareTo(a.durationMs));

    return sortedMetrics.take(10).map((metric) => {
      'operation': metric.operationName,
      'duration_ms': metric.durationMs,
      'timestamp': metric.timestamp.toIso8601String(),
      'category': metric.category.name,
    }).toList();
  }

  /// Get memory usage information
  MemoryInfo getMemoryInfo() {
    // This is a simplified implementation
    // In a real app, you might want to use platform-specific APIs
    final processInfo = ProcessInfo.currentRss;
    final maxRss = ProcessInfo.maxRss;
    
    return MemoryInfo(
      totalMemory: maxRss,
      usedMemory: processInfo,
      freeMemory: maxRss - processInfo,
      usagePercentage: (processInfo / maxRss) * 100);
  }

  /// Start cleanup timer
  void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(_cleanupInterval, (timer) {
      _cleanupOldMetrics();
    });
  }

  /// Start memory monitoring
  void _startMemoryMonitoring() {
    _memoryCheckTimer?.cancel();
    _memoryCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final memoryInfo = getMemoryInfo();
      
      if (memoryInfo.usagePercentage > 80) {
        debugPrint('Performance: HIGH MEMORY USAGE - ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
      }
    });
  }

  /// Cleanup old metrics
  void _cleanupOldMetrics() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    
    while (_metrics.isNotEmpty && _metrics.first.timestamp.isBefore(cutoff)) {
      _metrics.removeFirst();
    }
    
    // Clean up cancelled operations
    _activeOperations.removeWhere((id, stopwatch) {
      // Remove operations that have been running for more than 1 hour
      return stopwatch.elapsed > const Duration(hours: 1);
    });
  }

  /// Generate operation ID
  String _generateOperationId(String operationName) {
    return '${operationName}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Stream of performance metrics
  Stream<PerformanceMetric> get metricsStream => _metricsStreamController.stream;

  /// Dispose resources
  void dispose() {
    _cleanupTimer?.cancel();
    _memoryCheckTimer?.cancel();
    _metricsStreamController.close();
  }
}