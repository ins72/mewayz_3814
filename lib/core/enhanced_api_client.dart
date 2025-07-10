import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import './network_resilience_service.dart';
import './performance_monitor.dart';
import './production_config.dart';
import './resilient_error_handler.dart';
import './storage_service.dart';

/// Enhanced API client with comprehensive error handling and performance optimization
class EnhancedApiClient {
  static final EnhancedApiClient _instance = EnhancedApiClient._internal();
  factory EnhancedApiClient() => _instance;
  EnhancedApiClient._internal();

  late Dio _dio;
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  final NetworkResilienceService _networkService = NetworkResilienceService();
  final PerformanceMonitor _performanceMonitor = PerformanceMonitor();
  final StorageService _storageService = StorageService();

  final Map<String, CancelToken> _activeCancelTokens = {};
  final Map<String, Completer<Response>> _pendingRequests = {};

  bool _isInitialized = false;

  /// Initialize the enhanced API client
  Future<void> initialize() async {
    if (_isInitialized) return;

    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: ProductionConfig.baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': '${ProductionConfig.appName}/${ProductionConfig.appVersion}',
      });

    await _setupInterceptors();
    _networkService.initialize();
    _performanceMonitor.initialize();
    
    _isInitialized = true;
    debugPrint('Enhanced API client initialized');
  }

  /// Setup comprehensive interceptors
  Future<void> _setupInterceptors() async {
    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _handleRequest(options, handler);
        },
        onResponse: (response, handler) async {
          await _handleResponse(response, handler);
        },
        onError: (error, handler) async {
          await _handleError(error, handler);
        }));

    // Retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          await _handleRetryLogic(error, handler);
        }));

    // Performance monitoring interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final operationName = 'api_${options.method.toLowerCase()}_${_extractEndpointName(options.path)}';
          _performanceMonitor.startOperation(
            operationName,
            customId: options.extra['request_id'] as String?,
            
            metadata: {
              'method': options.method,
              'path': options.path,
              'has_data': options.data != null,
            });
          handler.next(options);
        },
        onResponse: (response, handler) {
          final operationName = 'api_${response.requestOptions.method.toLowerCase()}_${_extractEndpointName(response.requestOptions.path)}';
          _performanceMonitor.endOperation(
            operationName,
            customId: response.requestOptions.extra['request_id'] as String?,
            
            metadata: {
              'status_code': response.statusCode,
              'response_size': response.data?.toString().length ?? 0,
            });
          handler.next(response);
        },
        onError: (error, handler) {
          final operationName = 'api_${error.requestOptions.method.toLowerCase()}_${_extractEndpointName(error.requestOptions.path)}';
          _performanceMonitor.endOperation(
            operationName,
            customId: error.requestOptions.extra['request_id'] as String?,
            
            metadata: {
              'error_type': error.type.toString(),
              'status_code': error.response?.statusCode,
              'error_message': error.message,
            });
          handler.next(error);
        }));
  }

  /// Handle request preprocessing
  Future<void> _handleRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Add request ID for tracking
      final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';
      options.extra['request_id'] = requestId;

      // Add authentication token
      final token = await _storageService.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Add request tracking
      _activeCancelTokens[requestId] = CancelToken();
      options.cancelToken = _activeCancelTokens[requestId];

      // Log request in debug mode
      if (kDebugMode) {
        debugPrint('API Request: ${options.method} ${options.uri}');
        debugPrint('Headers: ${options.headers}');
        if (options.data != null) {
          debugPrint('Data: ${options.data}');
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(DioException(
        requestOptions: options,
        error: e,
        type: DioExceptionType.unknown));
    }
  }

  /// Handle response post-processing
  Future<void> _handleResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      // Clean up tracking
      final requestId = response.requestOptions.extra['request_id'] as String?;
      if (requestId != null) {
        _activeCancelTokens.remove(requestId);
        _pendingRequests.remove(requestId);
      }

      // Log response in debug mode
      if (kDebugMode) {
        debugPrint('API Response: ${response.statusCode} ${response.requestOptions.uri}');
        debugPrint('Data: ${response.data}');
      }

      // Validate response structure
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('error')) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: data['error']);
        }
      }

      handler.next(response);
    } catch (e) {
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: e,
        type: DioExceptionType.unknown));
    }
  }

  /// Handle error processing
  Future<void> _handleError(DioException error, ErrorInterceptorHandler handler) async {
    try {
      // Clean up tracking
      final requestId = error.requestOptions.extra['request_id'] as String?;
      if (requestId != null) {
        _activeCancelTokens.remove(requestId);
        _pendingRequests.remove(requestId);
      }

      // Process error through error handler
      await _errorHandler.handleError(
        error,
        context: 'api_request',
        metadata: {
          'method': error.requestOptions.method,
          'path': error.requestOptions.path,
          'status_code': error.response?.statusCode,
          'error_type': error.type.toString(),
        });

      handler.next(error);
    } catch (e) {
      handler.next(error);
    }
  }

  /// Handle retry logic
  Future<void> _handleRetryLogic(DioException error, ErrorInterceptorHandler handler) async {
    try {
      // Check if this is a retryable error
      if (!_isRetryableError(error)) {
        handler.next(error);
        return;
      }

      // Check if we haven't exceeded retry limit
      final retryCount = error.requestOptions.extra['retry_count'] as int? ?? 0;
      if (retryCount >= ProductionConfig.maxRetryAttempts) {
        handler.next(error);
        return;
      }

      // Handle specific retry scenarios
      if (error.response?.statusCode == 401) {
        final tokenRefreshed = await _refreshAuthToken();
        if (tokenRefreshed) {
          final response = await _retryRequest(error.requestOptions, retryCount + 1);
          handler.resolve(response);
          return;
        }
      }

      // General retry with backoff
      await Future.delayed(Duration(seconds: retryCount + 1));
      final response = await _retryRequest(error.requestOptions, retryCount + 1);
      handler.resolve(response);
    } catch (e) {
      handler.next(error);
    }
  }

  /// Check if error is retryable
  bool _isRetryableError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return statusCode == 401 || statusCode == 429 || (statusCode != null && statusCode >= 500);
      default:
        return false;
    }
  }

  /// Retry request with updated options
  Future<Response> _retryRequest(RequestOptions options, int retryCount) async {
    final newOptions = options.copyWith();
    newOptions.extra['retry_count'] = retryCount;
    
    // Update auth token if needed
    final token = await _storageService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      newOptions.headers['Authorization'] = 'Bearer $token';
    }

    return await _dio.fetch(newOptions);
  }

  /// Refresh authentication token
  Future<bool> _refreshAuthToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newToken != null) {
          await _storageService.saveAuthToken(newToken);
        }
        if (newRefreshToken != null) {
          await _storageService.saveRefreshToken(newRefreshToken);
        }

        return true;
      }

      return false;
    } catch (e) {
      // Clear tokens on refresh failure
      await _storageService.clearAuthData();
      return false;
    }
  }

  /// Extract endpoint name from path
  String _extractEndpointName(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.isNotEmpty ? segments.first : 'unknown';
  }

  /// Enhanced GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool useCache = true,
  }) async {
    await _ensureInitialized();
    
    return await _networkService.resilientRequest<T>(
      'GET',
      '${ProductionConfig.baseUrl}$path',
      queryParameters: queryParameters,
      options: options,
      useCache: useCache);
  }

  /// Enhanced POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _ensureInitialized();
    
    return await _networkService.resilientRequest<T>(
      'POST',
      '${ProductionConfig.baseUrl}$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      useCache: false,
      queueWhenOffline: true);
  }

  /// Enhanced PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _ensureInitialized();
    
    return await _networkService.resilientRequest<T>(
      'PUT',
      '${ProductionConfig.baseUrl}$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      useCache: false,
      queueWhenOffline: true);
  }

  /// Enhanced DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _ensureInitialized();
    
    return await _networkService.resilientRequest<T>(
      'DELETE',
      '${ProductionConfig.baseUrl}$path',
      data: data,
      queryParameters: queryParameters,
      options: options,
      useCache: false,
      queueWhenOffline: false);
  }

  /// Enhanced file upload with progress tracking
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String? fileName,
    Map<String, dynamic>? additionalFields,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    await _ensureInitialized();
    
    return await _performanceMonitor.measureAsync(
      'file_upload',
      () async {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName ?? file.path.split('/').last),
          if (additionalFields != null) ...additionalFields,
        });

        return await _dio.post<T>(
          path,
          data: formData,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken);
      },
      
      metadata: {
        'file_size': await file.length(),
        'file_name': fileName ?? file.path.split('/').last,
      });
  }

  /// Cancel all active requests
  void cancelAllRequests() {
    for (final cancelToken in _activeCancelTokens.values) {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Request cancelled by user');
      }
    }
    _activeCancelTokens.clear();
    _pendingRequests.clear();
  }

  /// Cancel specific request
  void cancelRequest(String requestId) {
    final cancelToken = _activeCancelTokens[requestId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Request cancelled by user');
      _activeCancelTokens.remove(requestId);
      _pendingRequests.remove(requestId);
    }
  }

  /// Get API client statistics
  Map<String, dynamic> getApiStats() {
    return {
      'active_requests': _activeCancelTokens.length,
      'pending_requests': _pendingRequests.length,
      'network_stats': _networkService.getNetworkStats(),
      'performance_stats': _performanceMonitor.getPerformanceStats(),
      'error_stats': _errorHandler.getErrorStatistics(),
    };
  }

  /// Ensure client is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Dispose resources
  void dispose() {
    cancelAllRequests();
    _networkService.dispose();
    _performanceMonitor.dispose();
    _errorHandler.dispose();
  }
}