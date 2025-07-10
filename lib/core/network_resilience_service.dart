import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import './performance_monitor.dart';
import './resilient_error_handler.dart';

/// Queued request structure
class QueuedRequest {
  final String method;
  final String url;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final DateTime timestamp;
  final Completer<Response> completer;

  QueuedRequest({
    required this.method,
    required this.url,
    this.data,
    this.queryParameters,
    this.options,
    required this.timestamp,
    required this.completer,
  });
}

/// Cached response structure
class CachedResponse {
  final Response response;
  final DateTime timestamp;
  final Duration cacheExpiration;

  CachedResponse({
    required this.response,
    required this.timestamp,
    required this.cacheExpiration,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > cacheExpiration;
}

/// Network resilience service with retry logic and offline support
class NetworkResilienceService {
  static final NetworkResilienceService _instance = NetworkResilienceService._internal();
  factory NetworkResilienceService() => _instance;
  NetworkResilienceService._internal();

  final Connectivity _connectivity = Connectivity();
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  final PerformanceMonitor _performanceMonitor = PerformanceMonitor();
  
  bool _isOnline = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Map<String, QueuedRequest> _offlineQueue = {};
  final Map<String, CachedResponse> _responseCache = {};
  
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);
  static const Duration _maxRetryDelay = Duration(seconds: 30);
  static const Duration _cacheExpiration = Duration(minutes: 30);

  /// Initialize network monitoring
  void initialize() {
    _startConnectivityMonitoring();
    _startOfflineQueueProcessing();
    debugPrint('Network resilience service initialized');
  }

  /// Start connectivity monitoring
  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _handleConnectivityChange([result]);
    });
    
    // Check initial connectivity
    _connectivity.checkConnectivity().then((result) {
      _handleConnectivityChange([result]);
    });
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
    
    if (_isOnline && !wasOnline) {
      debugPrint('Network: Connection restored');
      _processOfflineQueue();
    } else if (!_isOnline && wasOnline) {
      debugPrint('Network: Connection lost');
    }
  }

  /// Resilient HTTP request with retry logic
  Future<Response<T>> resilientRequest<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useCache = true,
    bool queueWhenOffline = true,
    int maxRetries = _maxRetries,
  }) async {
    final operationName = 'network_request_${method.toUpperCase()}';
    
    return await _performanceMonitor.measureAsync<Response<T>>(
      operationName,
      () => _executeResilientRequest<T>(
        method,
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        useCache: useCache,
        queueWhenOffline: queueWhenOffline,
        maxRetries: maxRetries),
      
      metadata: {
        'method': method,
        'url': url,
        'has_data': data != null,
        'use_cache': useCache,
      });
  }

  /// Execute resilient request with retry logic
  Future<Response<T>> _executeResilientRequest<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useCache = true,
    bool queueWhenOffline = true,
    int maxRetries = _maxRetries,
  }) async {
    // Check cache first for GET requests
    if (method.toUpperCase() == 'GET' && useCache) {
      final cachedResponse = _getCachedResponse(url, queryParameters);
      if (cachedResponse != null) {
        debugPrint('Network: Using cached response for $url');
        return cachedResponse as Response<T>;
      }
    }

    // If offline, queue request if allowed
    if (!_isOnline && queueWhenOffline) {
      return _queueOfflineRequest<T>(
        method,
        url,
        data: data,
        queryParameters: queryParameters,
        options: options);
    }

    // Execute request with retry logic
    return await _executeRequestWithRetry<T>(
      method,
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      useCache: useCache,
      maxRetries: maxRetries);
  }

  /// Execute request with retry logic
  Future<Response<T>> _executeRequestWithRetry<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useCache = true,
    int maxRetries = _maxRetries,
    int currentRetry = 0,
  }) async {
    try {
      final response = await _makeHttpRequest<T>(
        method,
        url,
        data: data,
        queryParameters: queryParameters,
        options: options);

      // Cache successful GET responses
      if (method.toUpperCase() == 'GET' && useCache && response.statusCode == 200) {
        _cacheResponse(url, queryParameters, response);
      }

      return response;
    } catch (error) {
      final shouldRetry = _shouldRetryRequest(error, currentRetry, maxRetries);
      
      if (shouldRetry) {
        final retryDelay = _calculateRetryDelay(currentRetry);
        debugPrint('Network: Retrying request in ${retryDelay.inSeconds}s (attempt ${currentRetry + 1}/$maxRetries)');
        
        await Future.delayed(retryDelay);
        
        return _executeRequestWithRetry<T>(
          method,
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          useCache: useCache,
          maxRetries: maxRetries,
          currentRetry: currentRetry + 1);
      }

      // Handle error through error handler
      await _errorHandler.handleError(
        error,
        context: 'network_request',
        metadata: {
          'method': method,
          'url': url,
          'retry_count': currentRetry,
        });

      rethrow;
    }
  }

  /// Make HTTP request using Dio
  Future<Response<T>> _makeHttpRequest<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final dio = Dio();
    
    switch (method.toUpperCase()) {
      case 'GET':
        return await dio.get<T>(
          url,
          queryParameters: queryParameters,
          options: options);
      case 'POST':
        return await dio.post<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options);
      case 'PUT':
        return await dio.put<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options);
      case 'DELETE':
        return await dio.delete<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options);
      case 'PATCH':
        return await dio.patch<T>(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options);
      default:
        throw UnsupportedError('HTTP method $method is not supported');
    }
  }

  /// Check if request should be retried
  bool _shouldRetryRequest(dynamic error, int currentRetry, int maxRetries) {
    if (currentRetry >= maxRetries) {
      return false;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          // Retry on 5xx errors and 429 (rate limit)
          return statusCode != null && (statusCode >= 500 || statusCode == 429);
        default:
          return false;
      }
    }

    return false;
  }

  /// Calculate retry delay with exponential backoff
  Duration _calculateRetryDelay(int retryCount) {
    final delay = _baseRetryDelay.inMilliseconds * pow(2, retryCount);
    final delayWithJitter = delay + Random().nextInt(1000); // Add jitter
    return Duration(milliseconds: min(delayWithJitter.toInt(), _maxRetryDelay.inMilliseconds));
  }

  /// Queue offline request
  Future<Response<T>> _queueOfflineRequest<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    final requestId = '${method}_${url}_${DateTime.now().millisecondsSinceEpoch}';
    final completer = Completer<Response<T>>();
    
    _offlineQueue[requestId] = QueuedRequest(
      method: method,
      url: url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      timestamp: DateTime.now(),
      completer: completer as Completer<Response>);

    debugPrint('Network: Queued offline request: $method $url');
    
    return completer.future;
  }

  /// Process offline queue when connection is restored
  void _processOfflineQueue() {
    if (_offlineQueue.isEmpty) return;

    debugPrint('Network: Processing ${_offlineQueue.length} queued requests');
    
    final requests = Map<String, QueuedRequest>.from(_offlineQueue);
    _offlineQueue.clear();

    for (final entry in requests.entries) {
      final request = entry.value;
      
      // Check if request is too old
      if (DateTime.now().difference(request.timestamp) > const Duration(hours: 1)) {
        request.completer.completeError(
          TimeoutException('Queued request expired', const Duration(hours: 1)));
        continue;
      }

      // Execute queued request
      _executeResilientRequest(
        request.method,
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: request.options,
        useCache: false,
        queueWhenOffline: false).then((response) {
        request.completer.complete(response);
      }).catchError((error) {
        request.completer.completeError(error);
      });
    }
  }

  /// Start offline queue processing timer
  void _startOfflineQueueProcessing() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_isOnline && _offlineQueue.isNotEmpty) {
        _processOfflineQueue();
      }
    });
  }

  /// Cache response
  void _cacheResponse(String url, Map<String, dynamic>? queryParameters, Response response) {
    final cacheKey = _generateCacheKey(url, queryParameters);
    _responseCache[cacheKey] = CachedResponse(
      response: response,
      timestamp: DateTime.now(),
      cacheExpiration: _cacheExpiration);
  }

  /// Get cached response
  Response? _getCachedResponse(String url, Map<String, dynamic>? queryParameters) {
    final cacheKey = _generateCacheKey(url, queryParameters);
    final cachedResponse = _responseCache[cacheKey];
    
    if (cachedResponse != null && !cachedResponse.isExpired) {
      return cachedResponse.response;
    }

    // Remove expired cache
    if (cachedResponse != null && cachedResponse.isExpired) {
      _responseCache.remove(cacheKey);
    }

    return null;
  }

  /// Generate cache key
  String _generateCacheKey(String url, Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) {
      return url;
    }
    
    final sortedParams = queryParameters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    final paramString = sortedParams.map((e) => '${e.key}=${e.value}').join('&');
    return '$url?$paramString';
  }

  /// Clear cache
  void clearCache() {
    _responseCache.clear();
    debugPrint('Network: Cache cleared');
  }

  /// Clear offline queue
  void clearOfflineQueue() {
    for (final request in _offlineQueue.values) {
      request.completer.completeError(Exception('Offline queue cleared'));
    }
    _offlineQueue.clear();
    _responseCache.clear();
  }

  /// Get network statistics
  Map<String, dynamic> getNetworkStats() {
    final now = DateTime.now();
    
    return {
      'is_online': _isOnline,
      'cached_responses': _responseCache.length,
      'queued_requests': _offlineQueue.length,
      'cache_hit_ratio': _calculateCacheHitRatio(),
      'oldest_queued_request': _offlineQueue.isEmpty ? null : 
          _offlineQueue.values.fold<DateTime?>(null, (oldest, request) => 
              oldest == null || request.timestamp.isBefore(oldest) ? request.timestamp : oldest)
          ?.toIso8601String(),
    };
  }

  /// Calculate cache hit ratio
  double _calculateCacheHitRatio() {
    // This is a simplified calculation
    // In a real implementation, you'd track hits and misses
    return _responseCache.isEmpty ? 0.0 : 0.8; // Placeholder
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription.cancel();
    
    // Complete all pending requests with error
    for (final request in _offlineQueue.values) {
      request.completer.completeError(Exception('Service disposed'));
    }
    _offlineQueue.clear();
    _responseCache.clear();
  }
}