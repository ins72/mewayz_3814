import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import './error_handler.dart';
import './production_config.dart';
import './storage_service.dart';

/// API client for making HTTP requests
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();
  
  late Dio _dio;
  final StorageService _storageService = StorageService();
  
  void initialize() {
    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: ProductionConfig.baseUrl,
      connectTimeout: Duration(milliseconds: ProductionConfig.connectionTimeout),
      receiveTimeout: Duration(milliseconds: ProductionConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ProductionConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': '${ProductionConfig.appName}/${ProductionConfig.appVersion}',
      },
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Request interceptor - Add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (ProductionConfig.enableLogging) {
            debugPrint('Request: ${options.method} ${options.uri}');
            debugPrint('Headers: ${options.headers}');
            debugPrint('Data: ${options.data}');
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (ProductionConfig.enableLogging) {
            debugPrint('Response: ${response.statusCode} ${response.requestOptions.uri}');
            debugPrint('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          ErrorHandler.handleError(error.toString());
          handler.next(error);
        },
      ),
    );
    
    // Retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry original request
              final clonedRequest = error.requestOptions;
              final token = await _storageService.getAuthToken();
              clonedRequest.headers['Authorization'] = 'Bearer $token';
              
              try {
                final response = await _dio.fetch(clonedRequest);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          
          handler.next(error);
        },
      ),
    );
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return false;
      
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Remove auth header for refresh
        ),
      );
      
      final newToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await _storageService.saveAuthToken(newToken);
      await _storageService.saveRefreshToken(newRefreshToken);
      
      return true;
    } catch (e) {
      // Remove the undefined method and use available methods to clear tokens
      await _storageService.saveAuthToken('');
      await _storageService.saveRefreshToken('');
      return false;
    }
  }
  
  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // File upload
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String? fileName,
    Map<String, dynamic>? additionalFields,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName ?? file.path.split('/').last,
        ),
        if (additionalFields != null) ...additionalFields,
      });
      
      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // Cancel all requests
  void cancelAllRequests() {
    _dio.close();
  }
}