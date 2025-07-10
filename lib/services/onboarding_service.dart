import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

enum OnboardingGoal {
  sellProducts('sell_products', 'Sell products or services'),
  showcaseWork('showcase_work', 'Showcase my work'),
  acceptPayments('accept_payments', 'Accept payments'),
  buildBrand('build_brand', 'Build a personal brand'),
  bookAppointments('book_appointments', 'Book appointments'),
  other('other', 'Other');

  const OnboardingGoal(this.value, this.title);
  final String value;
  final String title;
}

enum SetupStepStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  skipped('skipped');

  const SetupStepStatus(this.value);
  final String value;
}

class OnboardingService {
  static OnboardingService? _instance;
  static OnboardingService get instance => _instance ??= OnboardingService._();
  
  OnboardingService._();

  late SupabaseClient _client;
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      developer.log('Initializing Onboarding Service...', name: 'OnboardingService');
      
      // Get Supabase client from the service
      final supabaseService = SupabaseService.instance;
      _client = await supabaseService.client;
      
      _isInitialized = true;
      developer.log('Onboarding Service initialized successfully', name: 'OnboardingService');
      
    } catch (e) {
      developer.log('Onboarding Service initialization failed: $e', name: 'OnboardingService');
      rethrow;
    }
  }

  // Save user goals
  Future<void> saveUserGoals(List<OnboardingGoal> goals, {String? customGoalDescription}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Clear existing goals
      await _client
          .from('user_goals')
          .delete()
          .eq('user_id', userId);

      // Insert new goals
      final goalData = goals.asMap().entries.map((entry) {
        final index = entry.key;
        final goal = entry.value;
        
        return {
          'user_id': userId,
          'goal': goal.value,
          'is_primary': index == 0,
          'custom_goal_description': goal == OnboardingGoal.other ? customGoalDescription : null,
        };
      }).toList();

      await _client
          .from('user_goals')
          .insert(goalData);

      // Generate smart setup checklist
      await _generateSetupChecklist(goals);

    } catch (e) {
      ErrorHandler.handleError('Failed to save user goals: $e');
      rethrow;
    }
  }

  // Generate setup checklist based on goals
  Future<void> _generateSetupChecklist(List<OnboardingGoal> goals) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final goalValues = goals.map((g) => g.value).toList();
      
      await _client.rpc('generate_setup_checklist', params: {
        'user_uuid': userId,
        'selected_goals': goalValues,
      });

    } catch (e) {
      ErrorHandler.handleError('Failed to generate setup checklist: $e');
      rethrow;
    }
  }

  // Get user goals
  Future<List<Map<String, dynamic>>> getUserGoals() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_goals')
          .select('*')
          .eq('user_id', userId)
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get user goals: $e');
      rethrow;
    }
  }

  // Get setup checklist
  Future<List<Map<String, dynamic>>> getSetupChecklist() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('setup_checklist')
          .select('*')
          .eq('user_id', userId)
          .order('order_index');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get setup checklist: $e');
      rethrow;
    }
  }

  // Update setup step status
  Future<void> updateSetupStepStatus(String stepKey, SetupStepStatus status) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('setup_checklist')
          .update({
            'status': status.value,
            'completed_at': status == SetupStepStatus.completed ? DateTime.now().toIso8601String() : null,
          })
          .eq('user_id', userId)
          .eq('step_key', stepKey);

      // Update overall onboarding progress
      await _updateOnboardingProgress();

    } catch (e) {
      ErrorHandler.handleError('Failed to update setup step status: $e');
      rethrow;
    }
  }

  // Update onboarding progress
  Future<void> _updateOnboardingProgress() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client.rpc('update_onboarding_progress', params: {
        'user_uuid': userId,
      });

    } catch (e) {
      ErrorHandler.handleError('Failed to update onboarding progress: $e');
      rethrow;
    }
  }

  // Get onboarding progress
  Future<Map<String, dynamic>?> getOnboardingProgress() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('onboarding_progress')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get onboarding progress: $e');
      rethrow;
    }
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('onboarding_progress')
          .update({
            'is_completed': true,
            'completed_at': DateTime.now().toIso8601String(),
            'completion_percentage': 100.0,
          })
          .eq('user_id', userId);

    } catch (e) {
      ErrorHandler.handleError('Failed to complete onboarding: $e');
      rethrow;
    }
  }

  // Get feature modules for user
  Future<List<Map<String, dynamic>>> getUserFeatureModules() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_feature_modules')
          .select('*')
          .eq('user_id', userId)
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get user feature modules: $e');
      rethrow;
    }
  }

  // Enable feature module
  Future<void> enableFeatureModule(String module, {String subscriptionTier = 'free'}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('user_feature_modules')
          .upsert({
            'user_id': userId,
            'module': module,
            'is_enabled': true,
            'enabled_at': DateTime.now().toIso8601String(),
            'subscription_tier': subscriptionTier,
          });

    } catch (e) {
      ErrorHandler.handleError('Failed to enable feature module: $e');
      rethrow;
    }
  }

  // Create link-in-bio page
  Future<Map<String, dynamic>> createLinkBioPage({
    required String title,
    required String url,
    String templateType = 'basic',
    Map<String, dynamic>? config,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('link_bio_pages')
          .insert({
            'user_id': userId,
            'page_title': title,
            'page_url': url,
            'template_type': templateType,
            'page_config': config ?? {},
            'is_published': false,
          })
          .select()
          .single();

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to create link-in-bio page: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('user_profiles')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

    } catch (e) {
      ErrorHandler.handleError('Failed to update user profile: $e');
      rethrow;
    }
  }
}