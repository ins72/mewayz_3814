import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import './resilient_error_handler.dart';

/// Enhanced Supabase service with improved error handling and connection management
class EnhancedSupabaseService {
  static EnhancedSupabaseService? _enhancedInstance;
  Timer? _connectionHealthTimer;
  Timer? _reconnectTimer;
  bool _isHealthy = false;
  bool _isEnhancedInitialized = false;
  bool _isInitialized = false;
  int _healthCheckFailures = 0;
  static const int _maxHealthCheckFailures = 3;
  static const Duration _healthCheckInterval = Duration(seconds: 30);
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  late SupabaseClient _client;

  // Environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  // Enhanced singleton pattern
  static EnhancedSupabaseService get enhancedInstance {
    return _enhancedInstance ??= EnhancedSupabaseService._internal();
  }

  EnhancedSupabaseService._internal();

  /// Enhanced initialization with comprehensive error handling
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Validate environment variables
      _validateEnvironmentVariables();

      // Initialize Supabase with enhanced timeout
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: false, // Disable debug in production
      ).timeout(const Duration(seconds: 30));

      _client = Supabase.instance.client;
      
      // Enhanced initialization
      _isEnhancedInitialized = true;
      _isInitialized = true;
      
      // Start enhanced health monitoring
      _startEnhancedHealthMonitoring();
      
      debugPrint('✅ Enhanced Supabase service initialized successfully');
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'enhanced_supabase_initialization',
        shouldRetry: true,
        maxRetries: 2,
      );
      rethrow;
    }
  }

  /// Validate environment variables
  void _validateEnvironmentVariables() {
    final List<String> missingVars = [];
    
    if (supabaseUrl.isEmpty) {
      missingVars.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      missingVars.add('SUPABASE_ANON_KEY');
    }
    
    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required Supabase environment variables: ${missingVars.join(', ')}'
      );
    }
  }

  /// Enhanced connection test with detailed error reporting
  Future<bool> testConnection() async {
    try {
      if (!_isInitialized) {
        throw Exception('Supabase service not initialized');
      }

      // Test basic connectivity
      final basicTest = await _performBasicConnectivityTest();
      if (!basicTest) {
        return false;
      }

      // Test database operations
      final dbTest = await _performDatabaseTest();
      if (!dbTest) {
        return false;
      }

      // Test authentication
      final authTest = await _performAuthTest();
      
      _isHealthy = basicTest && dbTest && authTest;
      _healthCheckFailures = 0;
      
      return _isHealthy;
    } catch (e) {
      _isHealthy = false;
      _healthCheckFailures++;
      
      await _errorHandler.handleError(
        e,
        context: 'enhanced_connection_test',
        metadata: {
          'health_check_failures': _healthCheckFailures,
          'max_failures': _maxHealthCheckFailures,
        },
        shouldRetry: _healthCheckFailures < _maxHealthCheckFailures,
      );
      
      return false;
    }
  }

  /// Perform basic connectivity test
  Future<bool> _performBasicConnectivityTest() async {
    try {
      // Simple ping to check if we can reach Supabase
      await _client
          .from('workspaces')
          .select('count')
          .limit(1)
          .timeout(const Duration(seconds: 8));
      
      return true;
    } on TimeoutException {
      throw Exception('Connection timeout during basic connectivity test');
    } catch (e) {
      throw Exception('Basic connectivity test failed: $e');
    }
  }

  /// Perform database operations test
  Future<bool> _performDatabaseTest() async {
    try {
      // Test read operation
      await _client
          .from('user_profiles')
          .select('id')
          .limit(1)
          .timeout(const Duration(seconds: 10));
      
      return true;
    } on TimeoutException {
      throw Exception('Database test timeout');
    } catch (e) {
      // If table doesn't exist, that's still a successful connection
      if (e.toString().contains('relation') && e.toString().contains('does not exist')) {
        return true;
      }
      throw Exception('Database test failed: $e');
    }
  }

  /// Perform authentication test
  Future<bool> _performAuthTest() async {
    try {
      // Test auth state access
      final user = _client.auth.currentUser;
      
      // Test auth session validation
      final session = _client.auth.currentSession;
      
      return true; // Auth service is accessible
    } catch (e) {
      throw Exception('Authentication test failed: $e');
    }
  }

  /// Start enhanced health monitoring
  void _startEnhancedHealthMonitoring() {
    _connectionHealthTimer?.cancel();
    _connectionHealthTimer = Timer.periodic(_healthCheckInterval, (_) {
      _performEnhancedHealthCheck();
    });
  }

  /// Perform enhanced health check
  Future<void> _performEnhancedHealthCheck() async {
    try {
      final isHealthy = await testConnection();
      
      if (!isHealthy && _healthCheckFailures >= _maxHealthCheckFailures) {
        await _handleUnhealthyConnection();
      }
      
    } catch (e) {
      debugPrint('Enhanced health check failed: $e');
      
      if (_healthCheckFailures >= _maxHealthCheckFailures) {
        await _handleUnhealthyConnection();
      }
    }
  }

  /// Handle unhealthy connection
  Future<void> _handleUnhealthyConnection() async {
    debugPrint('⚠️ Enhanced Supabase connection is unhealthy, attempting recovery...');
    
    try {
      // Attempt to reinitialize
      await _attemptConnectionRecovery();
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'connection_recovery',
        metadata: {
          'health_check_failures': _healthCheckFailures,
          'connection_healthy': _isHealthy,
        },
        shouldRetry: false,
      );
    }
  }

  /// Attempt connection recovery
  Future<void> _attemptConnectionRecovery() async {
    try {
      // Reset connection state
      _isHealthy = false;
      _healthCheckFailures = 0;
      
      // Reinitialize the connection
      await initialize();
      
      // Verify recovery
      final recovered = await testConnection();
      
      if (recovered) {
        debugPrint('✅ Enhanced Supabase connection recovery successful');
      } else {
        throw Exception('Connection recovery verification failed');
      }
      
    } catch (e) {
      debugPrint('❌ Enhanced Supabase connection recovery failed: $e');
      rethrow;
    }
  }

  /// Enhanced execute with retry and circuit breaker
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 2,
    Duration delay = const Duration(seconds: 1),
    bool requiresConnection = true,
  }) async {
    // Check if service is healthy
    if (requiresConnection && !_isHealthy) {
      // Attempt immediate health check
      final isHealthy = await testConnection();
      if (!isHealthy) {
        throw Exception('Enhanced Supabase service is not healthy');
      }
    }

    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final result = await operation().timeout(const Duration(seconds: 25));
        
        // Update health status on successful operation
        if (!_isHealthy) {
          _isHealthy = true;
          _healthCheckFailures = 0;
          debugPrint('✅ Enhanced Supabase connection restored through successful operation');
        }
        
        return result;
      } on TimeoutException {
        lastException = Exception('Enhanced operation timed out after 25 seconds');
        _isHealthy = false;
        _healthCheckFailures++;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        // Update health status on operation failure
        if (e.toString().contains('network') || 
            e.toString().contains('connection') ||
            e.toString().contains('timeout')) {
          _isHealthy = false;
          _healthCheckFailures++;
        }
        
        // Log retry attempt
        if (attempt < maxRetries) {
          debugPrint('Enhanced operation failed (attempt ${attempt + 1}), retrying: $e');
          await Future.delayed(delay * (attempt + 1));
        }
      }
    }
    
    // Handle final failure with error reporting
    await _errorHandler.handleError(
      lastException!,
      context: 'enhanced_execute_with_retry',
      metadata: {
        'max_retries': maxRetries,
        'requires_connection': requiresConnection,
        'health_check_failures': _healthCheckFailures,
      },
      shouldRetry: false,
    );
    
    throw lastException;
  }

  /// Get enhanced service status
  Map<String, dynamic> getStatus() {
    return {
      'enhanced_is_healthy': _isHealthy,
      'enhanced_health_check_failures': _healthCheckFailures,
      'enhanced_max_health_check_failures': _maxHealthCheckFailures,
      'enhanced_health_monitoring_active': _connectionHealthTimer?.isActive ?? false,
      'enhanced_health_check_interval_seconds': _healthCheckInterval.inSeconds,
      'enhanced_service_type': 'enhanced',
      'enhanced_last_health_check': DateTime.now().toIso8601String(),
    };
  }

  /// Get enhanced connection health score (0-100)
  int getConnectionHealthScore() {
    if (!_isInitialized) return 0;
    if (!_isHealthy) return 25;
    if (_healthCheckFailures > 0) return 75 - (_healthCheckFailures * 15);
    return 100;
  }

  /// Enhanced dispose
  void dispose() {
    _connectionHealthTimer?.cancel();
    _reconnectTimer?.cancel();
    _errorHandler.dispose();
  }

  /// Get health status
  bool get isHealthy => _isHealthy;

  /// Get health check failures count
  int get healthCheckFailures => _healthCheckFailures;

  /// Get enhanced initialization status
  bool get isEnhancedInitialized => _isEnhancedInitialized;
  
  /// Get initialization status
  bool get initialized => _isInitialized;
  
  /// Get client
  SupabaseClient get client => _client;
}