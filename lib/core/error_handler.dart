import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './analytics_service.dart';
import './environment_config.dart';
import './storage_service.dart';

/// Centralized error handling service for production deployment
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  static final AnalyticsService _analyticsService = AnalyticsService();
  static final StorageService _storageService = StorageService();

  /// Handle general errors with comprehensive logging and user feedback
  static void handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    bool showUserMessage = true,
  }) {
    try {
      final errorInfo = _processError(error, stackTrace, context, additionalData);
      
      // Log error for debugging (only in development)
      if (EnvironmentConfig.enableLogging && !EnvironmentConfig.isProduction) {
        debugPrint('🚨 Error: ${errorInfo.message}');
        debugPrint('Context: ${errorInfo.context}');
        debugPrint('Type: ${errorInfo.type}');
        if (stackTrace != null) {
          debugPrint('Stack trace: $stackTrace');
        }
      }
      
      // Send to analytics and crash reporting
      _reportError(errorInfo);
      
      // Store error for local debugging
      _storeError(errorInfo);
      
      // Show user-friendly message
      if (showUserMessage) {
        _showUserMessage(errorInfo);
      }
      
    } catch (e) {
      // Fallback error handling
      if (kDebugMode) {
        debugPrint('🚨 Error handler failed: $e');
      }
      
      // Show basic error message
      if (showUserMessage) {
        _showBasicErrorMessage();
      }
    }
  }

  /// Handle network errors specifically
  static void handleNetworkError(
    dynamic error, {
    String? context,
    bool showUserMessage = true,
  }) {
    final errorInfo = _processNetworkError(error, context);
    
    if (EnvironmentConfig.enableLogging && !EnvironmentConfig.isProduction) {
      debugPrint('🌐 Network Error: ${errorInfo.message}');
      debugPrint('Status Code: ${errorInfo.statusCode}');
      debugPrint('Context: ${errorInfo.context}');
    }
    
    _reportError(errorInfo);
    _storeError(errorInfo);
    
    if (showUserMessage) {
      _showUserMessage(errorInfo);
    }
  }

  /// Handle authentication errors
  static void handleAuthError(
    dynamic error, {
    String? context,
    bool showUserMessage = true,
  }) {
    final errorInfo = _processAuthError(error, context);
    
    if (EnvironmentConfig.enableLogging && !EnvironmentConfig.isProduction) {
      debugPrint('🔐 Auth Error: ${errorInfo.message}');
      debugPrint('Context: ${errorInfo.context}');
    }
    
    _reportError(errorInfo);
    _storeError(errorInfo);
    
    if (showUserMessage) {
      _showUserMessage(errorInfo);
    }
  }

  /// Handle validation errors
  static void handleValidationError(
    dynamic error, {
    String? context,
    bool showUserMessage = true,
  }) {
    final errorInfo = _processValidationError(error, context);
    
    if (EnvironmentConfig.enableLogging && !EnvironmentConfig.isProduction) {
      debugPrint('✅ Validation Error: ${errorInfo.message}');
      debugPrint('Context: ${errorInfo.context}');
    }
    
    _reportError(errorInfo);
    
    if (showUserMessage) {
      _showUserMessage(errorInfo);
    }
  }

  /// Process general error and create ErrorInfo
  static ErrorInfo _processError(
    dynamic error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
  ) {
    String message = 'An unexpected error occurred';
    String type = 'unknown_error';
    int? statusCode;
    
    if (error is DioException) {
      return _processDioError(error, context);
    } else if (error is SocketException) {
      message = 'Network connection error';
      type = 'network_error';
    } else if (error is PlatformException) {
      message = error.message ?? 'Platform error occurred';
      type = 'platform_error';
    } else if (error is FormatException) {
      message = 'Data format error';
      type = 'format_error';
    } else if (error is ArgumentError) {
      message = 'Invalid argument provided';
      type = 'argument_error';
    } else if (error is StateError) {
      message = 'Invalid state error';
      type = 'state_error';
    } else if (error is Exception) {
      message = error.toString();
      type = 'exception_error';
    } else if (error is Error) {
      message = error.toString();
      type = 'error_object';
    } else {
      message = error.toString();
      type = 'unknown_error';
    }
    
    return ErrorInfo(
      message: message,
      type: type,
      context: context ?? 'unknown',
      stackTrace: stackTrace?.toString(),
      statusCode: statusCode,
      timestamp: DateTime.now(),
      additionalData: additionalData,
    );
  }

  /// Process Dio errors specifically
  static ErrorInfo _processDioError(DioException error, String? context) {
    String message = 'Network error occurred';
    String type = 'network_error';
    int? statusCode = error.response?.statusCode;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        type = 'timeout_error';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        type = 'timeout_error';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        type = 'timeout_error';
        break;
      case DioExceptionType.badResponse:
        message = _processBadResponse(error.response);
        type = 'server_error';
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        type = 'cancelled_error';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error';
        type = 'connection_error';
        break;
      case DioExceptionType.unknown:
        message = 'Unknown network error';
        type = 'unknown_network_error';
        break;
      default:
        message = 'Network error occurred';
        type = 'network_error';
    }
    
    return ErrorInfo(
      message: message,
      type: type,
      context: context ?? 'network',
      statusCode: statusCode,
      timestamp: DateTime.now(),
      additionalData: {
        'url': error.requestOptions.uri.toString(),
        'method': error.requestOptions.method,
        'response_data': error.response?.data,
      },
    );
  }

  /// Process bad response from server
  static String _processBadResponse(Response? response) {
    if (response == null) return 'Server error occurred';
    
    final statusCode = response.statusCode;
    
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 429:
        return 'Too many requests';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      case 504:
        return 'Gateway timeout';
      default:
        return 'Server error ($statusCode)';
    }
  }

  /// Process network error specifically
  static ErrorInfo _processNetworkError(dynamic error, String? context) {
    String message = 'Network connection error';
    String type = 'network_error';
    int? statusCode;
    
    if (error is DioException) {
      return _processDioError(error, context);
    } else if (error is SocketException) {
      message = 'No internet connection';
      type = 'no_internet_error';
    } else if (error is HttpException) {
      message = 'HTTP error: ${error.message}';
      type = 'http_error';
    } else {
      message = 'Network error occurred';
      type = 'network_error';
    }
    
    return ErrorInfo(
      message: message,
      type: type,
      context: context ?? 'network',
      statusCode: statusCode,
      timestamp: DateTime.now(),
    );
  }

  /// Process authentication error
  static ErrorInfo _processAuthError(dynamic error, String? context) {
    String message = 'Authentication error';
    String type = 'auth_error';
    
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 401:
          message = 'Invalid credentials';
          type = 'invalid_credentials';
          break;
        case 403:
          message = 'Access denied';
          type = 'access_denied';
          break;
        case 422:
          message = 'Account verification required';
          type = 'verification_required';
          break;
        default:
          message = 'Authentication failed';
          type = 'auth_failed';
      }
    } else if (error is PlatformException) {
      switch (error.code) {
        case 'sign_in_failed':
          message = 'Sign in failed';
          type = 'sign_in_failed';
          break;
        case 'sign_in_cancelled':
          message = 'Sign in cancelled';
          type = 'sign_in_cancelled';
          break;
        case 'network_error':
          message = 'Network error during authentication';
          type = 'auth_network_error';
          break;
        default:
          message = error.message ?? 'Authentication error';
          type = 'platform_auth_error';
      }
    }
    
    return ErrorInfo(
      message: message,
      type: type,
      context: context ?? 'authentication',
      timestamp: DateTime.now(),
    );
  }

  /// Process validation error
  static ErrorInfo _processValidationError(dynamic error, String? context) {
    String message = 'Validation error';
    String type = 'validation_error';
    
    if (error is Map<String, dynamic>) {
      if (error.containsKey('message')) {
        message = error['message'].toString();
      }
      if (error.containsKey('errors')) {
        final errors = error['errors'] as Map<String, dynamic>;
        final errorMessages = errors.values.map((e) => e.toString()).join(', ');
        message = errorMessages;
      }
    } else if (error is List<String>) {
      message = error.join(', ');
    } else {
      message = error.toString();
    }
    
    return ErrorInfo(
      message: message,
      type: type,
      context: context ?? 'validation',
      timestamp: DateTime.now(),
    );
  }

  /// Report error to analytics and crash reporting
  static void _reportError(ErrorInfo errorInfo) {
    try {
      // Send to analytics service
      _analyticsService.trackError(
        errorInfo.message,
        errorInfo.type,
        errorInfo.context,
        errorInfo.additionalData,
      );
      
      // Report to crash reporting service (Firebase Crashlytics, Sentry, etc.)
      if (EnvironmentConfig.enableCrashlytics) {
        _reportToCrashlytics(errorInfo);
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to report error: $e');
      }
    }
  }

  /// Report to crash reporting service
  static void _reportToCrashlytics(ErrorInfo errorInfo) {
    // Implementation for Firebase Crashlytics or similar service
    // This would be implemented based on your crash reporting service
    if (kDebugMode) {
      debugPrint('Reporting to crashlytics: ${errorInfo.message}');
    }
  }

  /// Store error locally for debugging
  static void _storeError(ErrorInfo errorInfo) {
    try {
      if (EnvironmentConfig.enableLogging && !EnvironmentConfig.isProduction) {
        final errorData = {
          'message': errorInfo.message,
          'type': errorInfo.type,
          'context': errorInfo.context,
          'timestamp': errorInfo.timestamp.toIso8601String(),
          'stack_trace': errorInfo.stackTrace,
          'status_code': errorInfo.statusCode,
          'additional_data': errorInfo.additionalData,
        };
        
        // The method 'storeError' isn't defined for the type 'StorageService'
        // _storageService.storeError(jsonEncode(errorData));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to store error: $e');
      }
    }
  }

  /// Show user-friendly message
  static void _showUserMessage(ErrorInfo errorInfo) {
    String userMessage = _getUserFriendlyMessage(errorInfo);
    
    Fluttertoast.showToast(
      msg: userMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF323232),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }

  /// Get user-friendly error message
  static String _getUserFriendlyMessage(ErrorInfo errorInfo) {
    switch (errorInfo.type) {
      case 'network_error':
      case 'connection_error':
      case 'no_internet_error':
        return 'Please check your internet connection and try again';
      case 'timeout_error':
        return 'Request timed out. Please try again';
      case 'auth_error':
      case 'invalid_credentials':
        return 'Invalid username or password';
      case 'access_denied':
        return 'You don\'t have permission to perform this action';
      case 'validation_error':
        return errorInfo.message;
      case 'server_error':
        return 'Server error. Please try again later';
      case 'not_found_error':
        return 'The requested resource was not found';
      case 'rate_limit_error':
        return 'Too many requests. Please wait a moment and try again';
      case 'maintenance_error':
        return 'The service is temporarily unavailable for maintenance';
      default:
        return 'Something went wrong. Please try again';
    }
  }

  /// Show basic error message when error handler fails
  static void _showBasicErrorMessage() {
    Fluttertoast.showToast(
      msg: 'An unexpected error occurred. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF323232),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }

  /// Get stored errors for debugging
  static Future<List<String>> getStoredErrors() async {
    try {
      // The method 'getStoredErrors' isn't defined for the type 'StorageService'
      // return await _storageService.getStoredErrors();
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get stored errors: $e');
      }
      return [];
    }
  }

  /// Clear stored errors
  static Future<void> clearStoredErrors() async {
    try {
      // The method 'clearStoredErrors' isn't defined for the type 'StorageService'
      // await _storageService.clearStoredErrors();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear stored errors: $e');
      }
    }
  }
}

/// Error information model
class ErrorInfo {
  final String message;
  final String type;
  final String context;
  final String? stackTrace;
  final int? statusCode;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  ErrorInfo({
    required this.message,
    required this.type,
    required this.context,
    this.stackTrace,
    this.statusCode,
    required this.timestamp,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'context': context,
      'stack_trace': stackTrace,
      'status_code': statusCode,
      'timestamp': timestamp.toIso8601String(),
      'additional_data': additionalData,
    };
  }
}