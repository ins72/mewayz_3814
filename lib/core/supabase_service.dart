import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;

  // Private constructor
  SupabaseService._internal();

  // Singleton instance getter
  static SupabaseService get instance {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  // Environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  // Initialize Supabase
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define or env.json.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _client = Supabase.instance.client;
    _isInitialized = true;
  }

  // Client getter
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await initialize();
    }
    return _client;
  }

  // Synchronous client getter (use only after initialization)
  SupabaseClient get clientSync {
    if (!_isInitialized) {
      throw Exception('SupabaseService not initialized. Call initialize() first.');
    }
    return _client;
  }

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Reset instance (for testing)
  static void reset() {
    _instance = null;
  }

  // Validation method
  void validateEnvironmentVariables() {
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is not configured. Please check your env.json file.');
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is not configured. Please check your env.json file.');
    }
  }
}