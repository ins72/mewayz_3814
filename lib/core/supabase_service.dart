import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;
  Future<void>? _initFuture;
  Timer? _connectionHealthTimer;
  bool _isConnected = false;

  // Singleton pattern with proper initialization flow
  static SupabaseService get instance {
    return _instance ??= SupabaseService._internal();
  }

  SupabaseService._internal();

  // Factory constructor for backwards compatibility
  factory SupabaseService() => instance;

  // Environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  /// Initialize Supabase service with enhanced error handling and retry logic
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Ensure only one initialization runs at a time
    _initFuture ??= _performInitializationWithRetry();
    await _initFuture;
  }

  /// Perform initialization with retry logic
  Future<void> _performInitializationWithRetry({int maxRetries = 3}) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await _performInitialization();
        return;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        if (attempt < maxRetries - 1) {
          print('⚠️ Supabase initialization attempt ${attempt + 1} failed: $e');
          await Future.delayed(Duration(seconds: (attempt + 1) * 2)); // Exponential backoff
        }
      }
    }
    
    throw lastException ?? Exception('Supabase initialization failed after $maxRetries attempts');
  }

  /// Perform the actual initialization
  Future<void> _performInitialization() async {
    try {
      // Validate environment variables
      validateEnvironmentVariables();

      // Initialize Supabase with timeout
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: false, // Disable debug in production
      ).timeout(const Duration(seconds: 30));

      _client = Supabase.instance.client;
      
      // Test initial connection
      final connectionTest = await testConnection();
      _isConnected = connectionTest;
      
      if (connectionTest) {
        _isInitialized = true;
        _startConnectionHealthMonitoring();
        print('✅ Supabase initialized and connected successfully');
      } else {
        print('⚠️ Supabase initialized but connection test failed');
        _isInitialized = true; // Still mark as initialized for offline capability
      }
      
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Start monitoring connection health
  void _startConnectionHealthMonitoring() {
    _connectionHealthTimer?.cancel();
    _connectionHealthTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _checkConnectionHealth();
    });
  }

  /// Check connection health periodically
  Future<void> _checkConnectionHealth() async {
    try {
      final isHealthy = await testConnection();
      if (_isConnected != isHealthy) {
        _isConnected = isHealthy;
        print(_isConnected 
            ? '✅ Supabase connection restored' 
            : '⚠️ Supabase connection lost');
      }
    } catch (e) {
      if (_isConnected) {
        _isConnected = false;
        print('⚠️ Supabase connection health check failed: $e');
      }
    }
  }

  // Client getter (async) - ensures initialization
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await initialize();
    }
    return _client;
  }

  // Synchronous client getter (use only after ensuring initialization)
  SupabaseClient get clientSync {
    if (!_isInitialized) {
      throw Exception('SupabaseService not initialized. Call initialize() first or use async client getter.');
    }
    return _client;
  }

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Check if connected
  bool get isConnected => _isConnected;

  // Validation method with detailed error messages
  void validateEnvironmentVariables() {
    final List<String> missingVars = [];
    
    if (supabaseUrl.isEmpty) {
      missingVars.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      missingVars.add('SUPABASE_ANON_KEY');
    }
    
    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required Supabase environment variables: ${missingVars.join(', ')}\n'
        'Please configure these using --dart-define:\n'
        'flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key'
      );
    }

    // Validate URL format
    if (!supabaseUrl.startsWith('https://') || !supabaseUrl.contains('.supabase.co')) {
      throw Exception(
        'Invalid SUPABASE_URL format: $supabaseUrl\n'
        'Expected format: https://your-project.supabase.co'
      );
    }
  }

  /// Enhanced connection test with timeout and specific error handling
  Future<bool> testConnection() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      // Test with a simple query that should always work
      await _client
          .from('workspaces')
          .select('count')
          .limit(1)
          .timeout(const Duration(seconds: 10));
      
      return true;
    } on TimeoutException {
      print('Supabase connection test timed out');
      return false;
    } catch (e) {
      print('Supabase connection test failed: $e');
      return false;
    }
  }

  /// Execute query with retry logic
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 2,
    Duration delay = const Duration(seconds: 1),
  }) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        if (attempt < maxRetries) {
          print('Operation failed (attempt ${attempt + 1}), retrying: $e');
          await Future.delayed(delay * (attempt + 1));
        }
      }
    }
    
    throw lastException ?? Exception('Operation failed after ${maxRetries + 1} attempts');
  }

  /// Reset instance (for testing or re-initialization)
  static void reset() {
    _instance?._connectionHealthTimer?.cancel();
    _instance?._isInitialized = false;
    _instance?._initFuture = null;
    _instance?._isConnected = false;
    _instance = null;
  }

  /// Get connection status information
  Map<String, dynamic> getStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_connected': _isConnected,
      'has_url': supabaseUrl.isNotEmpty,
      'has_anon_key': supabaseAnonKey.isNotEmpty,
      'url_format_valid': supabaseUrl.startsWith('https://') && supabaseUrl.contains('.supabase.co'),
      'supabase_url': supabaseUrl.isNotEmpty ? '${supabaseUrl.substring(0, 20)}...' : 'Not configured',
      'health_monitoring_active': _connectionHealthTimer?.isActive ?? false,
    };
  }

  /// Dispose resources
  void dispose() {
    _connectionHealthTimer?.cancel();
    _connectionHealthTimer = null;
  }
}