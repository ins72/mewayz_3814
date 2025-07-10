import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import './resilient_error_handler.dart';

/// Enhanced error handler with backward compatibility
class ErrorHandler {
  static final List<String> _errorLog = [];
  static final ResilientErrorHandler _resilientHandler = ResilientErrorHandler();
  
  /// Handle general error with enhanced processing
  static Future<void> handleError(String error, {String? context}) async {
    _errorLog.add('${DateTime.now()}: $error');
    debugPrint('Error: $error');
    
    // Use resilient error handler for comprehensive processing
    await _resilientHandler.handleError(
      Exception(error),
      context: context,
      shouldRetry: false,
    );
  }

  /// Handle authentication error
  static Future<void> handleAuthError(String error) async {
    _errorLog.add('${DateTime.now()}: AUTH ERROR - $error');
    debugPrint('Auth Error: $error');
    
    await _resilientHandler.handleError(
      Exception(error),
      context: 'authentication',
      shouldRetry: false,
    );
  }

  /// Handle network error with retry capability
  static Future<void> handleNetworkError(String error, {VoidCallback? onRetry}) async {
    _errorLog.add('${DateTime.now()}: NETWORK ERROR - $error');
    debugPrint('Network Error: $error');
    
    await _resilientHandler.handleError(
      NetworkException(error),
      context: 'network',
      shouldRetry: true,
      onRetry: onRetry,
    );
  }

  /// Handle validation error
  static Future<void> handleValidationError(String error) async {
    _errorLog.add('${DateTime.now()}: VALIDATION ERROR - $error');
    debugPrint('Validation Error: $error');
    
    await _resilientHandler.handleError(
      ValidationException(error),
      context: 'validation',
      shouldRetry: false,
    );
  }

  /// Handle timeout error
  static Future<void> handleTimeoutError(String error, {VoidCallback? onRetry}) async {
    _errorLog.add('${DateTime.now()}: TIMEOUT ERROR - $error');
    debugPrint('Timeout Error: $error');
    
    await _resilientHandler.handleError(
      TimeoutException(error, const Duration(seconds: 30)),
      context: 'timeout',
      shouldRetry: true,
      onRetry: onRetry,
    );
  }

  /// Handle server error
  static Future<void> handleServerError(String error, {VoidCallback? onRetry}) async {
    _errorLog.add('${DateTime.now()}: SERVER ERROR - $error');
    debugPrint('Server Error: $error');
    
    await _resilientHandler.handleError(
      ServerException(error),
      context: 'server',
      shouldRetry: true,
      onRetry: onRetry,
    );
  }

  /// Handle critical error
  static Future<void> handleCriticalError(String error, {String? stackTrace}) async {
    _errorLog.add('${DateTime.now()}: CRITICAL ERROR - $error');
    debugPrint('Critical Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
    
    await _resilientHandler.handleError(
      CriticalException(error, stackTrace),
      context: 'critical',
      shouldRetry: false,
    );
  }

  /// Show success message
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show warning message
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Show info message
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Get error log
  static List<String> getErrorLog() {
    return List.from(_errorLog);
  }

  /// Clear error log
  static void clearErrorLog() {
    _errorLog.clear();
    _resilientHandler.clearErrorHistory();
  }

  /// Get error statistics
  static Map<String, dynamic> getErrorStatistics() {
    return _resilientHandler.getErrorStatistics();
  }

  /// Handle Flutter framework errors
  static void handleFlutterError(FlutterErrorDetails details) {
    _resilientHandler.handleError(
      details.exception,
      context: 'flutter_framework',
      metadata: {
        'library': details.library,
        'context': details.context?.toString(),
        'stack_trace': details.stack.toString(),
      },
      shouldRetry: false,
    );
  }

  /// Handle unhandled platform errors
  static bool handlePlatformError(Object error, StackTrace stackTrace) {
    _resilientHandler.handleError(
      error,
      context: 'platform',
      metadata: {
        'stack_trace': stackTrace.toString(),
      },
      shouldRetry: false,
    );
    return true;
  }

  /// Subscribe to error events
  static Stream<dynamic> get errorStream => 
      _resilientHandler.errorStream;

  /// Dispose error handler
  static void dispose() {
    _resilientHandler.dispose();
  }
}

/// Custom exception classes for better error categorization
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  
  @override
  String toString() => 'ServerException: $message';
}

class CriticalException implements Exception {
  final String message;
  final String? stackTrace;
  CriticalException(this.message, this.stackTrace);
  
  @override
  String toString() => 'CriticalException: $message';
}