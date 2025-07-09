export 'package:connectivity_plus/connectivity_plus.dart';
export '../routes/app_routes.dart';
export '../widgets/custom_icon_widget.dart';
export '../widgets/custom_image_widget.dart';
export '../theme/app_theme.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:sizer/sizer.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:dio/dio.dart' hide MultipartFile, Headers, Response;
export 'package:fl_chart/fl_chart.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:url_launcher/url_launcher.dart';
export 'production_config.dart';
export 'error_handler.dart';
export 'api_client.dart';
export 'storage_service.dart';
export 'analytics_service.dart';
export 'notification_service.dart';
export 'security_service.dart';
export 'supabase_service.dart';
export 'app_constants.dart';
export 'package:http/http.dart';
export 'package:permission_handler/permission_handler.dart';
// export 'package:image_picker/image_picker.dart';
// export 'package:intl/intl.dart';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
// Export Supabase classes selectively to avoid conflicts with custom exception classes
export 'package:supabase_flutter/supabase_flutter.dart' show 
  Supabase, 
  SupabaseClient, 
  User, 
  Session, 
  GoTrueClient, 
  PostgrestClient, 
  RealtimeClient, 
  StorageClient, 
  SupabaseAuth, 
  SupabaseQuery, 
  SupabaseQueryBuilder, 
  SupabaseFilterBuilder, 
  SupabaseRealtimeClient, 
  RealtimeChannel, 
  RealtimeSubscription, 
  Provider, 
  OtpType, 
  AuthResponse, 
  AuthUser, 
  UserResponse, 
  SignInWithPasswordCredentials, 
  SignUpWithPasswordCredentials, 
  AuthChangeEvent, 
  AuthState, 
  GotrueSubscription, 
  FileObject, 
  FileOptions, 
  SearchOptions, 
  SortBy, 
  TransformOptions, 
  CreateSignedUrlOptions, 
  UploadResponse, 
  PostgrestException, 
  PostgrestResponse, 
  PostgrestList, 
  PostgrestSingle, 
  PostgrestMaybeSingle, 
  RealtimeException, 
  RealtimeMessage, 
  RealtimePayload, 
  RealtimePresence, 
  RealtimePostgresChanges, 
  RealtimePostgresInsertPayload, 
  RealtimePostgresUpdatePayload, 
  RealtimePostgresDeletePayload;
export '../services/auth_service.dart';
export '../services/onboarding_service.dart';
export '../widgets/custom_error_widget.dart';