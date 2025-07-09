import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorHandler {
  static final List<String> _errorLog = [];
  
  static void handleError(String error) {
    _errorLog.add('${DateTime.now()}: $error');
    debugPrint('Error: $error');
    
    // Only show toast in debug mode to avoid overwhelming users
    if (kDebugMode) {
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  static void handleAuthError(String error) {
    _errorLog.add('${DateTime.now()}: AUTH ERROR - $error');
    debugPrint('Auth Error: $error');
    
    // Auth errors are important for user experience
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void handleNetworkError(String error) {
    _errorLog.add('${DateTime.now()}: NETWORK ERROR - $error');
    debugPrint('Network Error: $error');
    
    Fluttertoast.showToast(
      msg: 'Network error: Please check your connection',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  static void handleValidationError(String error) {
    _errorLog.add('${DateTime.now()}: VALIDATION ERROR - $error');
    debugPrint('Validation Error: $error');
    
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.amber,
      textColor: Colors.black,
    );
  }

  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static List<String> getErrorLog() {
    return List.from(_errorLog);
  }

  static void clearErrorLog() {
    _errorLog.clear();
  }
}