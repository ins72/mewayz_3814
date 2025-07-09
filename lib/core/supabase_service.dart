import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Convenience getter for synchronous access (use with caution)
  SupabaseClient get syncClient {
    if (!_isInitialized) {
      throw Exception('SupabaseService not initialized. Call client getter first.');
    }
    return _client;
  }

  // Auth convenience methods
  Future<AuthResponse> signUp(String email, String password, {Map<String, dynamic>? metadata}) async {
    final client = await this.client;
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final client = await this.client;
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    final client = await this.client;
    await client.auth.signOut();
  }

  // Current user
  User? get currentUser {
    if (!_isInitialized) return null;
    return _client.auth.currentUser;
  }

  // Auth state stream
  Stream<AuthState> get authStateChanges {
    if (!_isInitialized) {
      return Stream.error('SupabaseService not initialized');
    }
    return _client.auth.onAuthStateChange;
  }
}