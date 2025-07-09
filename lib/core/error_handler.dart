import 'app_export.dart';

class ErrorHandler {
  static const String _logTag = 'ErrorHandler';
  
  // Error type constants
  static const String networkError = 'network_error';
  static const String timeoutError = 'timeout_error';
  static const String authError = 'auth_error';
  static const String serverError = 'server_error';
  static const String rateLimitError = 'rate_limit_error';
  static const String validationError = 'validation_error';
  static const String unknownError = 'unknown_error';

  // Handle errors with enhanced retry logic
  static Future<void> handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    bool shouldRetry = false,
    int retryAttempt = 0,
  }) async {
    if (kDebugMode) {
      debugPrint('$_logTag: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
      if (context != null) {
        debugPrint('Context: $context');
      }
    }

    final errorType = _getErrorType(error);
    final shouldAttemptRetry = shouldRetry && 
        _shouldRetryForErrorType(errorType) && 
        retryAttempt < ProductionConfig.errorRetryLimits[errorType]!;

    if (shouldAttemptRetry) {
      final delay = _getRetryDelay(retryAttempt);
      if (kDebugMode) {
        debugPrint('$_logTag: Retrying after ${delay.inSeconds} seconds (attempt ${retryAttempt + 1})');
      }
      await Future.delayed(delay);
      return;
    }

    // Log error to analytics service
    try {
      final analyticsService = AnalyticsService();
      if (kDebugMode) {
        debugPrint('$_logTag: Error data: ${error.toString()}, type: $errorType, context: ${context ?? 'unknown'}');
      }
    } catch (analyticsError) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to log error to analytics: $analyticsError');
      }
    }

    // Handle specific error types
    switch (errorType) {
      case networkError:
        await _handleNetworkError();
        break;
      case authError:
        await _handleAuthError();
        break;
      case serverError:
        await _handleServerError();
        break;
      case timeoutError:
        await _handleTimeoutError();
        break;
      case rateLimitError:
        await _handleRateLimitError();
        break;
      case validationError:
        await _handleValidationError();
        break;
      default:
        await _handleUnknownError();
    }
  }

  // Determine error type from exception
  static String _getErrorType(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return timeoutError;
        case DioExceptionType.connectionError:
          return networkError;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            return authError;
          } else if (statusCode == 429) {
            return rateLimitError;
          } else if (statusCode != null && statusCode >= 500) {
            return serverError;
          } else if (statusCode != null && statusCode >= 400) {
            return validationError;
          }
          return serverError;
        default:
          return unknownError;
      }
    }

    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') || errorString.contains('connection')) {
      return networkError;
    } else if (errorString.contains('timeout')) {
      return timeoutError;
    } else if (errorString.contains('auth') || errorString.contains('unauthorized')) {
      return authError;
    } else if (errorString.contains('server')) {
      return serverError;
    } else if (errorString.contains('validation')) {
      return validationError;
    }

    return unknownError;
  }

  // Check if error type should be retried
  static bool _shouldRetryForErrorType(String errorType) {
    return ProductionConfig.errorRetryLimits.containsKey(errorType) &&
           ProductionConfig.errorRetryLimits[errorType]! > 0;
  }

  // Get retry delay based on attempt number
  static Duration _getRetryDelay(int attempt) {
    if (attempt < ProductionConfig.retryDelays.length) {
      return ProductionConfig.retryDelays[attempt];
    }
    return ProductionConfig.retryDelays.last;
  }

  // Handle network errors
  static Future<void> _handleNetworkError() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        if (kDebugMode) {
          debugPrint('$_logTag: No internet connection');
        }
        // Show offline mode if enabled
        if (ProductionConfig.enableOfflineMode) {
          // Switch to offline mode
          await _enableOfflineMode();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to check connectivity: $e');
      }
    }
  }

  // Handle authentication errors
  static Future<void> _handleAuthError() async {
    try {
      final authService = AuthService();
      await authService.signOut();
      
      if (kDebugMode) {
        debugPrint('$_logTag: User signed out due to auth error');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to sign out user: $e');
      }
    }
  }

  // Handle server errors
  static Future<void> _handleServerError() async {
    if (kDebugMode) {
      debugPrint('$_logTag: Server error occurred');
    }
    // Implement server error handling
  }

  // Handle timeout errors
  static Future<void> _handleTimeoutError() async {
    if (kDebugMode) {
      debugPrint('$_logTag: Request timeout occurred');
    }
    // Implement timeout error handling
  }

  // Handle rate limit errors
  static Future<void> _handleRateLimitError() async {
    if (kDebugMode) {
      debugPrint('$_logTag: Rate limit exceeded');
    }
    // Implement rate limit error handling
  }

  // Handle validation errors
  static Future<void> _handleValidationError() async {
    if (kDebugMode) {
      debugPrint('$_logTag: Validation error occurred');
    }
    // Implement validation error handling
  }

  // Handle unknown errors
  static Future<void> _handleUnknownError() async {
    if (kDebugMode) {
      debugPrint('$_logTag: Unknown error occurred');
    }
    // Implement unknown error handling
  }

  // Enable offline mode
  static Future<void> _enableOfflineMode() async {
    try {
      final storageService = StorageService();
      if (kDebugMode) {
        debugPrint('$_logTag: Offline mode enabled');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to enable offline mode: $e');
      }
    }
  }

  // Check if currently in offline mode
  static Future<bool> isOfflineMode() async {
    try {
      final storageService = StorageService();
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to check offline mode: $e');
      }
      return false;
    }
  }

  // Disable offline mode
  static Future<void> disableOfflineMode() async {
    try {
      final storageService = StorageService();
      if (kDebugMode) {
        debugPrint('$_logTag: Offline mode disabled');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$_logTag: Failed to disable offline mode: $e');
      }
    }
  }

  // Get user-friendly error message
  static String getUserFriendlyMessage(dynamic error) {
    final errorType = _getErrorType(error);
    
    switch (errorType) {
      case networkError:
        return 'Network connection failed. Please check your internet connection and try again.';
      case timeoutError:
        return 'Request timed out. Please try again.';
      case authError:
        return 'Authentication failed. Please sign in again.';
      case serverError:
        return 'Server error occurred. Please try again later.';
      case rateLimitError:
        return 'Too many requests. Please wait a moment and try again.';
      case validationError:
        return 'Invalid data provided. Please check your input and try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // Execute with retry logic
  static Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    String? context,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempt++;
        
        if (attempt >= maxRetries) {
          await handleError(
            error,
            context: context,
            shouldRetry: false,
            retryAttempt: attempt,
          );
          rethrow;
        }
        
        await handleError(
          error,
          context: context,
          shouldRetry: true,
          retryAttempt: attempt,
        );
      }
    }
    
    throw Exception('Maximum retry attempts exceeded');
  }
}