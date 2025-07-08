import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './production_config.dart';

/// Global error handler for the application
class ErrorHandler {
  static void handleError(dynamic error, {StackTrace? stackTrace}) {
    if (ProductionConfig.enableLogging) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
    
    // Send to crash reporting service in production
    if (ProductionConfig.isProduction) {
      _sendToCrashlytics(error, stackTrace);
    }
    
    // Show user-friendly error message
    _showErrorToUser(error);
  }
  
  static void _sendToCrashlytics(dynamic error, StackTrace? stackTrace) {
    // Implementation for Firebase Crashlytics or other crash reporting service
    // This would typically use FirebaseCrashlytics.instance.recordError()
    if (ProductionConfig.enableCrashlytics) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
  
  static void _showErrorToUser(dynamic error) {
    String message = _getErrorMessage(error);
    
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  
  static String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.badResponse:
          return _handleHttpError(error.response?.statusCode);
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.unknown:
          return 'An unexpected error occurred. Please try again.';
        default:
          return 'Network error. Please try again.';
      }
    }
    
    // Handle other types of errors
    if (error is FormatException) {
      return 'Invalid data format received.';
    }
    
    if (error is TypeError) {
      return 'Data processing error. Please try again.';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }
  
  static String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error. Please try again later.';
    }
  }
}

/// Exception classes for specific error types
class AuthException implements Exception {
  final String message;
  final int? code;
  
  AuthException(this.message, {this.code});
  
  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  
  NetworkException(this.message, {this.statusCode});
  
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;
  
  ValidationException(this.message, {this.errors});
  
  @override
  String toString() => 'ValidationException: $message';
}

class StorageException implements Exception {
  final String message;
  
  StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}

class PermissionException implements Exception {
  final String message;
  
  PermissionException(this.message);
  
  @override
  String toString() => 'PermissionException: $message';
}