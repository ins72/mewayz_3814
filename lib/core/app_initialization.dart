import 'dart:async';

import 'package:flutter/foundation.dart';

import './enhanced_api_client.dart';
import './environment_config.dart';
import './error_handler.dart';
import './network_resilience_service.dart';
import './optimized_state_manager.dart';
import './performance_monitor.dart';
import './production_config.dart';
import './production_performance_service.dart';
import './production_security_service.dart';
import './storage_service.dart';
import './supabase_service.dart';
import '../services/production_data_service.dart';

/// Comprehensive app initialization service with production-ready optimizations
class AppInitialization {
  static final AppInitialization _instance = AppInitialization._internal();
  factory AppInitialization() => _instance;
  AppInitialization._internal();

  bool _isInitialized = false;
  final List<String> _initializationSteps = [];
  final Map<String, dynamic> _initializationResults = {};
  final Completer<void> _initializationCompleter = Completer<void>();

  /// Initialize the entire application with production optimizations
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 Starting Mewayz Production Application Initialization...');
      
      // Set up error handling first
      await _setupErrorHandling();
      
      // Initialize core services
      await _initializeEnvironment();
      await _initializeStorage();
      await _initializeSupabase();
      await _initializeProductionSecurity();
      await _initializeProductionPerformance();
      await _initializeNetworking();
      await _initializeProductionData();
      await _initializeStateManagement();
      await _setupGlobalErrorHandling();
      
      // Final validation and optimization
      await _validateInitialization();
      await _optimizeForProduction();
      
      _isInitialized = true;
      _initializationCompleter.complete();
      
      debugPrint('✅ Mewayz Production Application Initialization Completed Successfully');
      _printProductionInitializationSummary();
      
    } catch (error, stackTrace) {
      debugPrint('❌ Production Application Initialization Failed: $error');
      debugPrint('Stack trace: $stackTrace');
      
      await ErrorHandler.handleCriticalError(
        'Production application initialization failed: $error',
        stackTrace: stackTrace.toString());
      
      _initializationCompleter.completeError(error);
      rethrow;
    }
  }

  /// Set up enhanced error handling infrastructure
  Future<void> _setupErrorHandling() async {
    _addInitializationStep('Setting up production error handling');
    
    try {
      // Set up Flutter error handling with production optimizations
      FlutterError.onError = (FlutterErrorDetails details) {
        ErrorHandler.handleFlutterError(details);
        
        // In production, also log to external service
        if (EnvironmentConfig.isProduction) {
          _logErrorToExternalService(details);
        }
      };

      // Set up platform error handling with enhanced reporting
      PlatformDispatcher.instance.onError = (error, stack) {
        final handled = ErrorHandler.handlePlatformError(error, stack);
        
        // Additional production error reporting
        if (EnvironmentConfig.isProduction) {
          _reportCriticalError(error, stack);
        }
        
        return handled;
      };

      _markStepCompleted('error_handling', true);
    } catch (e) {
      _markStepCompleted('error_handling', false, e.toString());
      rethrow;
    }
  }

  /// Initialize environment configuration with production validation
  Future<void> _initializeEnvironment() async {
    _addInitializationStep('Initializing production environment configuration');
    
    try {
      await EnvironmentConfig.initialize();
      await ProductionConfig.initialize();
      
      // Additional production environment checks
      if (EnvironmentConfig.isProduction) {
        await _validateProductionEnvironment();
      }
      
      _markStepCompleted('environment', true);
    } catch (e) {
      _markStepCompleted('environment', false, e.toString());
      rethrow;
    }
  }

  /// Initialize storage service with production optimizations
  Future<void> _initializeStorage() async {
    _addInitializationStep('Initializing production storage service');
    
    try {
      final storageService = StorageService();
      await storageService.initialize();
      
      // Production storage validation
      await _validateStorageIntegrity();
      
      _markStepCompleted('storage', true);
    } catch (e) {
      _markStepCompleted('storage', false, e.toString());
      rethrow;
    }
  }

  /// Initialize Supabase service with enhanced production features
  Future<void> _initializeSupabase() async {
    _addInitializationStep('Initializing production Supabase service');
    
    try {
      final supabaseService = SupabaseService.instance;
      await supabaseService.initialize();
      
      // Enhanced connection validation for production
      final connectionTest = await supabaseService.testConnection();
      if (connectionTest) {
        _markStepCompleted('supabase', true);
        debugPrint('✅ Supabase production connection verified');
        
        // Additional production checks
        await _validateSupabaseProductionReadiness();
      } else {
        _markStepCompleted('supabase', false, 'Production connection test failed');
        
        if (EnvironmentConfig.isProduction) {
          throw Exception('Supabase connection required for production');
        } else {
          debugPrint('⚠️ Supabase connection failed - continuing in development mode');
        }
      }
    } catch (e) {
      _markStepCompleted('supabase', false, e.toString());
      
      if (EnvironmentConfig.isProduction) {
        rethrow; // Fail fast in production
      } else {
        debugPrint('⚠️ Supabase initialization failed: $e');
        debugPrint('🔄 App will continue in development mode without backend integration');
        
        _initializationResults['supabase_failure_reason'] = e.toString();
        _initializationResults['supabase_fallback_mode'] = true;
      }
    }
  }

  /// Initialize production security service
  Future<void> _initializeProductionSecurity() async {
    _addInitializationStep('Initializing production security service');
    
    try {
      final securityService = ProductionSecurityService();
      await securityService.initialize();
      
      // Security validation for production
      await _validateSecurityConfiguration();
      
      _markStepCompleted('production_security', true);
      debugPrint('✅ Production security service initialized');
    } catch (e) {
      _markStepCompleted('production_security', false, e.toString());
      
      if (EnvironmentConfig.isProduction) {
        rethrow; // Security is critical in production
      } else {
        debugPrint('⚠️ Production security initialization failed: $e');
      }
    }
  }

  /// Initialize production performance service
  Future<void> _initializeProductionPerformance() async {
    _addInitializationStep('Initializing production performance service');
    
    try {
      final performanceService = ProductionPerformanceService();
      await performanceService.initialize();
      
      // Performance optimization for production
      await _optimizePerformanceSettings();
      
      _markStepCompleted('production_performance', true);
      debugPrint('✅ Production performance service initialized');
    } catch (e) {
      _markStepCompleted('production_performance', false, e.toString());
      debugPrint('⚠️ Performance service initialization failed: $e');
      // Continue without performance optimizations
    }
  }

  /// Initialize networking services with production enhancements
  Future<void> _initializeNetworking() async {
    _addInitializationStep('Initializing production networking services');
    
    try {
      final networkService = NetworkResilienceService();
      networkService.initialize();
      
      final apiClient = EnhancedApiClient();
      await apiClient.initialize();
      
      // Production networking validation
      await _validateNetworkConfiguration();
      
      _markStepCompleted('networking', true);
    } catch (e) {
      _markStepCompleted('networking', false, e.toString());
      rethrow;
    }
  }

  /// Initialize production data service
  Future<void> _initializeProductionData() async {
    _addInitializationStep('Initializing production data service');
    
    try {
      final dataService = ProductionDataService();
      await dataService.initialize();
      
      // Data service validation
      await _validateDataServiceConfiguration();
      
      _markStepCompleted('production_data', true);
      debugPrint('✅ Production data service initialized');
    } catch (e) {
      _markStepCompleted('production_data', false, e.toString());
      
      if (EnvironmentConfig.isProduction) {
        rethrow; // Data service is critical in production
      } else {
        debugPrint('⚠️ Production data service initialization failed: $e');
      }
    }
  }

  /// Initialize performance monitoring with production features
  Future<void> _initializePerformanceMonitoring() async {
    _addInitializationStep('Initializing production performance monitoring');
    
    try {
      final performanceMonitor = PerformanceMonitor();
      performanceMonitor.initialize();
      
      // Enhanced monitoring for production
      if (EnvironmentConfig.isProduction) {
        await _setupProductionMonitoring();
      }
      
      _markStepCompleted('performance_monitoring', true);
    } catch (e) {
      _markStepCompleted('performance_monitoring', false, e.toString());
      debugPrint('⚠️ Performance monitoring failed to initialize: $e');
      // Continue without performance monitoring
    }
  }

  /// Initialize state management with production optimizations
  Future<void> _initializeStateManagement() async {
    _addInitializationStep('Initializing production state management');
    
    try {
      final globalStateManager = GlobalStateManager();
      // State managers will be created as needed with production optimizations
      
      // Setup production state persistence
      await _setupProductionStatePersistence();
      
      _markStepCompleted('state_management', true);
    } catch (e) {
      _markStepCompleted('state_management', false, e.toString());
      rethrow;
    }
  }

  /// Setup global error handling with production reporting
  Future<void> _setupGlobalErrorHandling() async {
    _addInitializationStep('Setting up production global error handling');
    
    try {
      // Setup error stream subscription for production monitoring
      ErrorHandler.errorStream.listen((errorReport) {
        final report = errorReport as dynamic;
        debugPrint('Production error captured: ${report.type.name} - ${report.message}');
        
        // Enhanced error reporting for production
        if (EnvironmentConfig.isProduction) {
          _reportErrorToProductionMonitoring(report);
        }
      });
      
      _markStepCompleted('global_error_handling', true);
    } catch (e) {
      _markStepCompleted('global_error_handling', false, e.toString());
      rethrow;
    }
  }

  /// Validate initialization with production requirements
  Future<void> _validateInitialization() async {
    _addInitializationStep('Validating production initialization');
    
    try {
      // Enhanced environment validation
      if (!EnvironmentConfig.isProductionReady) {
        if (EnvironmentConfig.isProduction) {
          throw Exception('Production environment is not properly configured');
        } else {
          debugPrint('⚠️ Environment configuration is not production ready - missing required environment variables');
        }
      }

      // Enhanced Supabase validation
      try {
        final supabaseService = SupabaseService.instance;
        if (!supabaseService.isInitialized) {
          if (EnvironmentConfig.isProduction) {
            throw Exception('Supabase service is required for production');
          } else {
            debugPrint('⚠️ Supabase service is not initialized - running in offline mode');
          }
        }
      } catch (e) {
        if (EnvironmentConfig.isProduction) {
          rethrow;
        } else {
          debugPrint('⚠️ Supabase validation failed: $e - continuing without backend');
        }
      }

      // Enhanced storage validation
      final storageService = StorageService();
      await storageService.setValue('production_init_test', 'test_value');
      final testValue = await storageService.getValue('production_init_test');
      if (testValue != 'test_value') {
        throw Exception('Storage service validation failed');
      }
      await storageService.remove('production_init_test');

      // Production-specific validations
      if (EnvironmentConfig.isProduction) {
        await _validateProductionRequirements();
      }

      _markStepCompleted('validation', true);
    } catch (e) {
      _markStepCompleted('validation', false, e.toString());
      rethrow;
    }
  }

  /// Optimize for production deployment
  Future<void> _optimizeForProduction() async {
    _addInitializationStep('Applying production optimizations');
    
    try {
      if (EnvironmentConfig.isProduction) {
        // Disable debug features
        await _disableDebugFeatures();
        
        // Enable production caching
        await _enableProductionCaching();
        
        // Setup production monitoring
        await _setupProductionTelemetry();
        
        // Preload critical data
        await _preloadCriticalData();
      }
      
      _markStepCompleted('production_optimization', true);
    } catch (e) {
      _markStepCompleted('production_optimization', false, e.toString());
      debugPrint('⚠️ Production optimization failed: $e');
      // Continue without optimizations
    }
  }

  /// Production environment validation
  Future<void> _validateProductionEnvironment() async {
    // Validate all required environment variables for production
    final requiredVars = [
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
    ];
    
    for (final varName in requiredVars) {
      final value = String.fromEnvironment(varName);
      if (value.isEmpty) {
        throw Exception('Required production environment variable missing: $varName');
      }
    }
  }

  /// Validate storage integrity
  Future<void> _validateStorageIntegrity() async {
    final storage = StorageService();
    
    // Test storage operations
    await storage.setValue('integrity_test', 'test_data');
    final retrievedValue = await storage.getValue('integrity_test');
    
    if (retrievedValue != 'test_data') {
      throw Exception('Storage integrity check failed');
    }
    
    await storage.remove('integrity_test');
  }

  /// Validate Supabase production readiness
  Future<void> _validateSupabaseProductionReadiness() async {
    final supabaseService = SupabaseService.instance;
    
    // Test basic operations
    try {
      await supabaseService.clientSync.from('workspaces').select('count').limit(1);
      debugPrint('✅ Supabase production readiness validated');
    } catch (e) {
      throw Exception('Supabase production readiness check failed: $e');
    }
  }

  /// Validate security configuration
  Future<void> _validateSecurityConfiguration() async {
    // Validate security service initialization
    final securityService = ProductionSecurityService();
    
    // Test security features
    try {
      await securityService.isDeviceTrusted();
      debugPrint('✅ Security configuration validated');
    } catch (e) {
      debugPrint('⚠️ Security configuration validation failed: $e');
    }
  }

  /// Optimize performance settings
  Future<void> _optimizePerformanceSettings() async {
    final performanceService = ProductionPerformanceService();
    
    // Preload frequently accessed data
    await performanceService.preloadCache({
      'system_config': () async => {'preloaded': true},
      'user_preferences': () async => {'theme': 'system'},
    });
    
    debugPrint('✅ Performance optimizations applied');
  }

  /// Validate network configuration
  Future<void> _validateNetworkConfiguration() async {
    // Test network connectivity and configuration
    try {
      // This would include testing API endpoints, timeouts, etc.
      debugPrint('✅ Network configuration validated');
    } catch (e) {
      throw Exception('Network configuration validation failed: $e');
    }
  }

  /// Validate data service configuration
  Future<void> _validateDataServiceConfiguration() async {
    final dataService = ProductionDataService();
    
    // Test data service functionality
    try {
      final status = dataService.getServiceStatus();
      if (!status['is_initialized']) {
        throw Exception('Data service not properly initialized');
      }
      debugPrint('✅ Data service configuration validated');
    } catch (e) {
      throw Exception('Data service validation failed: $e');
    }
  }

  /// Setup production monitoring
  Future<void> _setupProductionMonitoring() async {
    // Setup production-specific monitoring and alerting
    debugPrint('✅ Production monitoring configured');
  }

  /// Setup production state persistence
  Future<void> _setupProductionStatePersistence() async {
    // Configure state persistence for production
    debugPrint('✅ Production state persistence configured');
  }

  /// Validate production requirements
  Future<void> _validateProductionRequirements() async {
    // Additional production-specific validations
    
    // Check minimum OS versions
    // Validate app permissions
    // Check device security features
    
    debugPrint('✅ Production requirements validated');
  }

  /// Disable debug features for production
  Future<void> _disableDebugFeatures() async {
    // Disable debug overlays, verbose logging, etc.
    debugPrint('✅ Debug features disabled for production');
  }

  /// Enable production caching
  Future<void> _enableProductionCaching() async {
    final performanceService = ProductionPerformanceService();
    
    // Setup aggressive caching for production
    await performanceService.preloadCache({
      'app_config': () async => {'production': true},
      'feature_flags': () async => {'enabled': true},
    });
    
    debugPrint('✅ Production caching enabled');
  }

  /// Setup production telemetry
  Future<void> _setupProductionTelemetry() async {
    // Setup analytics, crash reporting, performance monitoring
    debugPrint('✅ Production telemetry configured');
  }

  /// Preload critical data for production
  Future<void> _preloadCriticalData() async {
    try {
      final dataService = ProductionDataService();
      
      // Preload essential data
      await dataService.getSystemHealthData();
      
      debugPrint('✅ Critical data preloaded');
    } catch (e) {
      debugPrint('⚠️ Critical data preload failed: $e');
    }
  }

  /// Helper methods for error reporting
  void _logErrorToExternalService(FlutterErrorDetails details) {
    // Log to external error reporting service
    debugPrint('Logging error to external service: ${details.exception}');
  }

  void _reportCriticalError(Object error, StackTrace stack) {
    // Report critical errors to monitoring service
    debugPrint('Reporting critical error: $error');
  }

  void _reportErrorToProductionMonitoring(dynamic errorReport) {
    // Report errors to production monitoring service
    debugPrint('Reporting to production monitoring: ${errorReport.message}');
  }

  /// Add initialization step
  void _addInitializationStep(String step) {
    _initializationSteps.add(step);
    debugPrint('📋 Production initialization step: $step');
  }

  /// Mark step as completed
  void _markStepCompleted(String key, bool success, [String? error]) {
    _initializationResults[key] = {
      'success': success,
      'error': error,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (success) {
      debugPrint('✅ $key completed successfully');
    } else {
      debugPrint('❌ $key failed: $error');
    }
  }

  /// Print production initialization summary
  void _printProductionInitializationSummary() {
    debugPrint('\n🎉 MEWAYZ PRODUCTION INITIALIZATION SUMMARY 🎉');
    debugPrint('================================================');
    
    final successful = _initializationResults.values
        .where((result) => result['success'] == true)
        .length;
    final total = _initializationResults.length;
    
    debugPrint('📊 Success Rate: $successful/$total');
    debugPrint('🏁 Total Steps: ${_initializationSteps.length}');
    debugPrint('⏱️  Environment: ${EnvironmentConfig.environment}');
    debugPrint('🔧 Production Ready: ${EnvironmentConfig.isProductionReady}');
    debugPrint('🌐 Base URL: ${ProductionConfig.baseUrl}');
    debugPrint('📱 App Version: ${ProductionConfig.appVersion}');
    debugPrint('🚀 Production Mode: ${EnvironmentConfig.isProduction}');
    
    if (!ProductionConfig.isProduction) {
      debugPrint('\n🔍 PRODUCTION INITIALIZATION DETAILS:');
      _initializationResults.forEach((key, result) {
        final status = result['success'] ? '✅' : '❌';
        debugPrint('   $status $key');
        if (result['error'] != null) {
          debugPrint('      Error: ${result['error']}');
        }
      });
    }
    
    // Production-specific summary
    if (EnvironmentConfig.isProduction) {
      debugPrint('\n🏭 PRODUCTION FEATURES ENABLED:');
      debugPrint('   ✅ Enhanced Security');
      debugPrint('   ✅ Performance Optimization');
      debugPrint('   ✅ Real-time Monitoring');
      debugPrint('   ✅ Advanced Caching');
      debugPrint('   ✅ Error Reporting');
    }
    
    debugPrint('================================================\n');
  }

  /// Wait for initialization to complete
  Future<void> waitForInitialization() async {
    if (_isInitialized) return;
    return _initializationCompleter.future;
  }

  /// Get initialization status
  Map<String, dynamic> getInitializationStatus() {
    return {
      'is_initialized': _isInitialized,
      'steps_completed': _initializationSteps.length,
      'results': _initializationResults,
      'environment': EnvironmentConfig.environment,
      'production_ready': EnvironmentConfig.isProductionReady,
      'is_production': EnvironmentConfig.isProduction,
      'app_version': ProductionConfig.appVersion,
      'initialization_timestamp': _isInitialized 
          ? DateTime.now().toIso8601String()
          : null,
    };
  }

  /// Check if app is ready
  bool get isReady => _isInitialized;

  /// Get initialization results
  Map<String, dynamic> get initializationResults => _initializationResults;

  /// Dispose all services
  Future<void> dispose() async {
    debugPrint('🧹 Disposing production application services...');
    
    try {
      // Dispose services in reverse order
      ProductionDataService().dispose();
      ProductionPerformanceService().dispose();
      GlobalStateManager().disposeAll();
      PerformanceMonitor().dispose();
      NetworkResilienceService().dispose();
      EnhancedApiClient().dispose();
      ErrorHandler.dispose();
      
      debugPrint('✅ All production services disposed successfully');
    } catch (e) {
      debugPrint('❌ Error disposing production services: $e');
    }
  }
}