import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:math';

/// Error types for categorization
enum ErrorType {
  network,
  authentication,
  validation,
  permission,
  timeout,
  server,
  client,
  unknown,
}

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Error report structure
class ErrorReport {
  final String id;
  final ErrorType type;
  final ErrorSeverity severity;
  final String message;
  final String? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final int retryCount;

  ErrorReport({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    this.stackTrace,
    required this.timestamp,
    this.metadata = const {},
    this.retryCount = 0,
  });

  ErrorReport copyWith({
    String? id,
    ErrorType? type,
    ErrorSeverity? severity,
    String? message,
    String? stackTrace,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    int? retryCount,
  }) {
    return ErrorReport(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      retryCount: retryCount ?? this.retryCount);
  }
}

/// Enhanced error handler with retry mechanisms and recovery strategies
class ResilientErrorHandler {
  static final ResilientErrorHandler _instance = ResilientErrorHandler._internal();
  factory ResilientErrorHandler() => _instance;
  ResilientErrorHandler._internal();

  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTime = {};
  final Map<String, Timer> _retryTimers = {};
  final List<ErrorReport> _errorReports = [];
  final StreamController<ErrorReport> _errorStreamController = StreamController<ErrorReport>.broadcast();

  /// Stream of error reports
  Stream<ErrorReport> get errorStream => _errorStreamController.stream;

  /// Handle error with automatic classification and recovery
  Future<bool> handleError(
    dynamic error, {
    String? context,
    Map<String, dynamic>? metadata,
    bool shouldRetry = true,
    int maxRetries = 3,
    VoidCallback? onRetry,
  }) async {
    try {
      final errorReport = _classifyError(error, context, metadata);
      _errorReports.add(errorReport);
      _errorStreamController.add(errorReport);

      // Log error based on severity
      _logError(errorReport);

      // Show user-friendly error message
      _showUserErrorMessage(errorReport);

      // Attempt automatic recovery if appropriate
      if (shouldRetry && _shouldRetry(errorReport)) {
        return await _attemptRecovery(errorReport, maxRetries, onRetry);
      }

      return false;
    } catch (e) {
      debugPrint('Error in error handler: $e');
      return false;
    }
  }

  /// Classify error type and severity
  ErrorReport _classifyError(
    dynamic error,
    String? context,
    Map<String, dynamic>? metadata) {
    final errorId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now();
    final errorMessage = error.toString();

    ErrorType type = ErrorType.unknown;
    ErrorSeverity severity = ErrorSeverity.medium;

    // Classify based on error type
    if (error is DioException) {
      type = _classifyDioError(error);
      severity = _getSeverityForDioError(error);
    } else if (error is TimeoutException) {
      type = ErrorType.timeout;
      severity = ErrorSeverity.medium;
    } else if (error is FormatException) {
      type = ErrorType.validation;
      severity = ErrorSeverity.low;
    } else if (error is UnauthorizedException) {
      type = ErrorType.authentication;
      severity = ErrorSeverity.high;
    } else if (error is PermissionException) {
      type = ErrorType.permission;
      severity = ErrorSeverity.high;
    } else if (error is FlutterError) {
      type = ErrorType.client;
      severity = ErrorSeverity.medium;
    }

    return ErrorReport(
      id: errorId,
      type: type,
      severity: severity,
      message: errorMessage,
      stackTrace: error is Error ? error.stackTrace.toString() : null,
      timestamp: timestamp,
      metadata: {
        'context': context,
        'dart_error_type': error.runtimeType.toString(),
        ...?metadata,
      });
  }

  /// Classify Dio specific errors
  ErrorType _classifyDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorType.timeout;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return ErrorType.authentication;
        } else if (statusCode != null && statusCode >= 500) {
          return ErrorType.server;
        } else {
          return ErrorType.client;
        }
      case DioExceptionType.cancel:
        return ErrorType.client;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return ErrorType.network;
      default:
        return ErrorType.unknown;
    }
  }

  /// Get severity for Dio errors
  ErrorSeverity _getSeverityForDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    
    if (statusCode == 401 || statusCode == 403) {
      return ErrorSeverity.high;
    } else if (statusCode != null && statusCode >= 500) {
      return ErrorSeverity.critical;
    } else if (error.type == DioExceptionType.connectionError) {
      return ErrorSeverity.medium;
    } else {
      return ErrorSeverity.low;
    }
  }

  /// Log error based on severity
  void _logError(ErrorReport errorReport) {
    final logMessage = '[${errorReport.severity.name.toUpperCase()}] ${errorReport.type.name}: ${errorReport.message}';
    
    switch (errorReport.severity) {
      case ErrorSeverity.low:
        debugPrint(logMessage);
        break;
      case ErrorSeverity.medium:
        debugPrint(logMessage);
        break;
      case ErrorSeverity.high:
        debugPrint(logMessage);
        if (errorReport.stackTrace != null) {
          debugPrint('Stack trace: ${errorReport.stackTrace}');
        }
        break;
      case ErrorSeverity.critical:
        debugPrint(logMessage);
        if (errorReport.stackTrace != null) {
          debugPrint('Stack trace: ${errorReport.stackTrace}');
        }
        // In production, you might want to send this to a crash reporting service
        break;
    }
  }

  /// Show user-friendly error messages
  void _showUserErrorMessage(ErrorReport errorReport) {
    String userMessage = _getUserFriendlyMessage(errorReport);
    Color backgroundColor = _getErrorColor(errorReport.severity);

    // Only show toast for medium and high severity errors
    if (errorReport.severity == ErrorSeverity.medium || 
        errorReport.severity == ErrorSeverity.high) {
      Fluttertoast.showToast(
        msg: userMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0);
    }
  }

  /// Get user-friendly error message
  String _getUserFriendlyMessage(ErrorReport errorReport) {
    switch (errorReport.type) {
      case ErrorType.network:
        return 'Please check your internet connection and try again.';
      case ErrorType.authentication:
        return 'Authentication failed. Please sign in again.';
      case ErrorType.validation:
        return 'Please check your input and try again.';
      case ErrorType.permission:
        return 'Permission denied. Please check your access rights.';
      case ErrorType.timeout:
        return 'Request timed out. Please try again.';
      case ErrorType.server:
        return 'Server error. Please try again later.';
      case ErrorType.client:
        return 'Something went wrong. Please try again.';
      case ErrorType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Get error color based on severity
  Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Colors.blue;
      case ErrorSeverity.medium:
        return Colors.orange;
      case ErrorSeverity.high:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.deepPurple;
    }
  }

  /// Check if error should be retried
  bool _shouldRetry(ErrorReport errorReport) {
    // Don't retry validation or permission errors
    if (errorReport.type == ErrorType.validation || 
        errorReport.type == ErrorType.permission) {
      return false;
    }

    // Check retry count
    final errorKey = '${errorReport.type.name}_${errorReport.message}';
    final currentCount = _errorCounts[errorKey] ?? 0;
    
    return currentCount < 3;
  }

  /// Attempt automatic recovery
  Future<bool> _attemptRecovery(
    ErrorReport errorReport,
    int maxRetries,
    VoidCallback? onRetry) async {
    final errorKey = '${errorReport.type.name}_${errorReport.message}';
    final currentCount = _errorCounts[errorKey] ?? 0;

    if (currentCount >= maxRetries) {
      return false;
    }

    // Increment error count
    _errorCounts[errorKey] = currentCount + 1;
    _lastErrorTime[errorKey] = DateTime.now();

    // Calculate delay with exponential backoff
    final delay = _calculateRetryDelay(currentCount);

    // Cancel existing timer
    _retryTimers[errorKey]?.cancel();

    // Create new retry timer
    final completer = Completer<bool>();
    _retryTimers[errorKey] = Timer(delay, () {
      onRetry?.call();
      completer.complete(true);
    });

    return completer.future;
  }

  /// Calculate retry delay with exponential backoff
  Duration _calculateRetryDelay(int retryCount) {
    final baseDelay = 1000; // 1 second
    final maxDelay = 30000; // 30 seconds
    final backoffFactor = 2;

    final delay = min(baseDelay * pow(backoffFactor, retryCount), maxDelay);
    return Duration(milliseconds: delay.round());
  }

  /// Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    
    final recentErrors = _errorReports
        .where((report) => report.timestamp.isAfter(last24Hours))
        .toList();

    final errorsByType = <String, int>{};
    final errorsBySeverity = <String, int>{};

    for (final report in recentErrors) {
      errorsByType[report.type.name] = (errorsByType[report.type.name] ?? 0) + 1;
      errorsBySeverity[report.severity.name] = (errorsBySeverity[report.severity.name] ?? 0) + 1;
    }

    return {
      'total_errors_24h': recentErrors.length,
      'errors_by_type': errorsByType,
      'errors_by_severity': errorsBySeverity,
      'most_common_error': errorsByType.entries
          .fold<MapEntry<String, int>?>(null, (prev, curr) => 
              prev == null || curr.value > prev.value ? curr : prev)
          ?.key,
      'error_rate': recentErrors.length / 24.0, // errors per hour
    };
  }

  /// Clear error history
  void clearErrorHistory() {
    _errorReports.clear();
    _errorCounts.clear();
    _lastErrorTime.clear();
    _retryTimers.values.forEach((timer) => timer.cancel());
    _retryTimers.clear();
  }

  /// Dispose resources
  void dispose() {
    _retryTimers.values.forEach((timer) => timer.cancel());
    _errorStreamController.close();
  }
}

/// Custom exception classes
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
  
  @override
  String toString() => 'PermissionException: $message';
}