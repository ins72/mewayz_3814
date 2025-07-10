import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;
  Future<void>? _initFuture;

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

  /// Initialize Supabase service with proper error handling
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Ensure only one initialization runs at a time
    _initFuture ??= _performInitialization();
    await _initFuture;
  }

  /// Perform the actual initialization
  Future<void> _performInitialization() async {
    try {
      // Validate environment variables
      validateEnvironmentVariables();

      // Initialize Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: false, // Disable debug in production
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      _isInitialized = false;
      rethrow;
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

  /// Test connection to Supabase
  Future<bool> testConnection() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      // Simple query to test connection
      await _client.from('workspaces').select('count').limit(1);
      return true;
    } catch (e) {
      print('Supabase connection test failed: $e');
      return false;
    }
  }

  /// Reset instance (for testing or re-initialization)
  static void reset() {
    _instance?._isInitialized = false;
    _instance?._initFuture = null;
    _instance = null;
  }

  /// Get connection status information
  Map<String, dynamic> getStatus() {
    return {
      'is_initialized': _isInitialized,
      'has_url': supabaseUrl.isNotEmpty,
      'has_anon_key': supabaseAnonKey.isNotEmpty,
      'url_format_valid': supabaseUrl.startsWith('https://') && supabaseUrl.contains('.supabase.co'),
      'supabase_url': supabaseUrl.isNotEmpty ? '${supabaseUrl.substring(0, 20)}...' : 'Not configured',
    };
  }
}