import 'dart:async';

import 'package:flutter/foundation.dart';

import './enhanced_api_client.dart';
import './environment_config.dart';
import './error_handler.dart';
import './network_resilience_service.dart';
import './optimized_state_manager.dart';
import './performance_monitor.dart';
import './production_config.dart';
import './storage_service.dart';
import './supabase_service.dart';

/// Comprehensive app initialization service
class AppInitialization {
  static final AppInitialization _instance = AppInitialization._internal();
  factory AppInitialization() => _instance;
  AppInitialization._internal();

  bool _isInitialized = false;
  final List<String> _initializationSteps = [];
  final Map<String, dynamic> _initializationResults = {};
  final Completer<void> _initializationCompleter = Completer<void>();

  /// Initialize the entire application
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 Starting Mewayz application initialization...');
      
      // Set up error handling first
      await _setupErrorHandling();
      
      // Initialize core services
      await _initializeEnvironment();
      await _initializeStorage();
      await _initializeSupabase();
      await _initializeNetworking();
      await _initializePerformanceMonitoring();
      await _initializeStateManagement();
      await _setupGlobalErrorHandling();
      
      // Validate initialization
      await _validateInitialization();
      
      _isInitialized = true;
      _initializationCompleter.complete();
      
      debugPrint('✅ Mewayz application initialization completed successfully');
      _printInitializationSummary();
      
    } catch (error, stackTrace) {
      debugPrint('❌ Application initialization failed: $error');
      debugPrint('Stack trace: $stackTrace');
      
      await ErrorHandler.handleCriticalError(
        'Application initialization failed: $error',
        stackTrace: stackTrace.toString());
      
      _initializationCompleter.completeError(error);
      rethrow;
    }
  }

  /// Set up error handling infrastructure
  Future<void> _setupErrorHandling() async {
    _addInitializationStep('Setting up error handling');
    
    try {
      // Set up Flutter error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        ErrorHandler.handleFlutterError(details);
      };

      // Set up platform error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        return ErrorHandler.handlePlatformError(error, stack);
      };

      _markStepCompleted('error_handling', true);
    } catch (e) {
      _markStepCompleted('error_handling', false, e.toString());
      rethrow;
    }
  }

  /// Initialize environment configuration
  Future<void> _initializeEnvironment() async {
    _addInitializationStep('Initializing environment configuration');
    
    try {
      await EnvironmentConfig.initialize();
      await ProductionConfig.initialize();
      
      _markStepCompleted('environment', true);
    } catch (e) {
      _markStepCompleted('environment', false, e.toString());
      rethrow;
    }
  }

  /// Initialize storage service
  Future<void> _initializeStorage() async {
    _addInitializationStep('Initializing storage service');
    
    try {
      final storageService = StorageService();
      await storageService.initialize();
      
      _markStepCompleted('storage', true);
    } catch (e) {
      _markStepCompleted('storage', false, e.toString());
      rethrow;
    }
  }

  /// Initialize Supabase service
  Future<void> _initializeSupabase() async {
    _addInitializationStep('Initializing Supabase service');
    
    try {
      final supabaseService = SupabaseService.instance;
      await supabaseService.initialize();
      
      _markStepCompleted('supabase', true);
    } catch (e) {
      _markStepCompleted('supabase', false, e.toString());
      rethrow;
    }
  }

  /// Initialize networking services
  Future<void> _initializeNetworking() async {
    _addInitializationStep('Initializing networking services');
    
    try {
      final networkService = NetworkResilienceService();
      networkService.initialize();
      
      final apiClient = EnhancedApiClient();
      await apiClient.initialize();
      
      _markStepCompleted('networking', true);
    } catch (e) {
      _markStepCompleted('networking', false, e.toString());
      rethrow;
    }
  }

  /// Initialize performance monitoring
  Future<void> _initializePerformanceMonitoring() async {
    _addInitializationStep('Initializing performance monitoring');
    
    try {
      final performanceMonitor = PerformanceMonitor();
      performanceMonitor.initialize();
      
      _markStepCompleted('performance', true);
    } catch (e) {
      _markStepCompleted('performance', false, e.toString());
      rethrow;
    }
  }

  /// Initialize state management
  Future<void> _initializeStateManagement() async {
    _addInitializationStep('Initializing state management');
    
    try {
      final globalStateManager = GlobalStateManager();
      // State managers will be created as needed
      
      _markStepCompleted('state_management', true);
    } catch (e) {
      _markStepCompleted('state_management', false, e.toString());
      rethrow;
    }
  }

  /// Setup global error handling
  Future<void> _setupGlobalErrorHandling() async {
    _addInitializationStep('Setting up global error handling');
    
    try {
      // Setup error stream subscription for monitoring
      ErrorHandler.errorStream.listen((errorReport) {
        debugPrint('Global error captured: ${(errorReport as dynamic).type.name} - ${(errorReport as dynamic).message}');
      });
      
      _markStepCompleted('global_error_handling', true);
    } catch (e) {
      _markStepCompleted('global_error_handling', false, e.toString());
      rethrow;
    }
  }

  /// Validate initialization
  Future<void> _validateInitialization() async {
    _addInitializationStep('Validating initialization');
    
    try {
      // Validate environment configuration
      if (!EnvironmentConfig.isProductionReady) {
        throw Exception('Environment configuration is not production ready');
      }

      // Validate Supabase connection
      final supabaseService = SupabaseService.instance;
      if (!supabaseService.isInitialized) {
        throw Exception('Supabase service is not initialized');
      }

      // Validate storage service
      final storageService = StorageService();
      await storageService.setValue('init_test', 'test_value');
      final testValue = await storageService.getValue('init_test');
      if (testValue != 'test_value') {
        throw Exception('Storage service validation failed');
      }

      _markStepCompleted('validation', true);
    } catch (e) {
      _markStepCompleted('validation', false, e.toString());
      rethrow;
    }
  }

  /// Add initialization step
  void _addInitializationStep(String step) {
    _initializationSteps.add(step);
    debugPrint('📋 Initialization step: $step');
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

  /// Print initialization summary
  void _printInitializationSummary() {
    debugPrint('\n🎉 MEWAYZ INITIALIZATION SUMMARY 🎉');
    debugPrint('==========================================');
    
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
    
    if (!ProductionConfig.isProduction) {
      debugPrint('\n🔍 INITIALIZATION DETAILS:');
      _initializationResults.forEach((key, result) {
        final status = result['success'] ? '✅' : '❌';
        debugPrint('   $status $key');
        if (result['error'] != null) {
          debugPrint('      Error: ${result['error']}');
        }
      });
    }
    
    debugPrint('==========================================\n');
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
    debugPrint('🧹 Disposing application services...');
    
    try {
      // Dispose services in reverse order
      GlobalStateManager().disposeAll();
      PerformanceMonitor().dispose();
      NetworkResilienceService().dispose();
      EnhancedApiClient().dispose();
      ErrorHandler.dispose();
      
      debugPrint('✅ All services disposed successfully');
    } catch (e) {
      debugPrint('❌ Error disposing services: $e');
    }
  }
}