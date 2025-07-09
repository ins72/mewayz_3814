
import '../core/app_export.dart';
import './routes/app_routes.dart' as app_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services with enhanced error handling
  await _initializeServices();

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // 🚨 CRITICAL: Device orientation and system UI setup - DO NOT REMOVE
  await _setupSystemUI();

  runApp(MyApp());
}

Future<void> _initializeServices() async {
  try {
    // Enhanced production readiness check
    if (ProductionConfig.enableLogging) {
      debugPrint('🚀 Initializing Mewayz App...');
      debugPrint('Production Readiness: ${ProductionConfig.configurationStatus}');
      final readiness = ProductionConfig.productionReadinessCheck;
      readiness.forEach((key, value) {
        debugPrint('$key: ${value ? "✅" : "❌"}');
      });
    }
    
    // Initialize services in proper order
    await _initializeSupabase();
    await _initializeStorage();
    await _initializeApiClient();
    await _initializeAnalytics();
    await _initializeNotifications();
    await _initializeSecurity();
    await _initializeAccessibility();
    
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ All services initialized successfully');
    }
  } catch (e, stackTrace) {
    ErrorHandler.handleError('Failed to initialize services: $e', stackTrace: stackTrace);
  }
}

Future<void> _initializeSupabase() async {
  try {
    SupabaseService();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Supabase initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Supabase initialization failed: $e');
    }
    rethrow;
  }
}

Future<void> _initializeStorage() async {
  try {
    final storageService = StorageService();
    await storageService.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Storage service initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Storage service initialization failed: $e');
    }
    rethrow;
  }
}

Future<void> _initializeApiClient() async {
  try {
    final apiClient = ApiClient();
    apiClient.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ API client initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ API client initialization failed: $e');
    }
    rethrow;
  }
}

Future<void> _initializeAnalytics() async {
  try {
    final analyticsService = AnalyticsService();
    await analyticsService.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Analytics service initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Analytics service initialization failed: $e');
    }
    // Analytics failure shouldn't stop app initialization
  }
}

Future<void> _initializeNotifications() async {
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Notification service initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Notification service initialization failed: $e');
    }
    // Notifications failure shouldn't stop app initialization
  }
}

Future<void> _initializeSecurity() async {
  try {
    final securityService = SecurityService();
    await securityService.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Security service initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Security service initialization failed: $e');
    }
    rethrow;
  }
}

Future<void> _initializeAccessibility() async {
  try {
    final accessibilityService = AccessibilityService.instance;
    await accessibilityService.initialize();
    if (ProductionConfig.enableLogging) {
      debugPrint('✅ Accessibility service initialized');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ Accessibility service initialization failed: $e');
    }
    // Accessibility failure shouldn't stop app initialization
  }
}

Future<void> _setupSystemUI() async {
  try {
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    if (ProductionConfig.enableLogging) {
      debugPrint('✅ System UI configured');
    }
  } catch (e) {
    if (ProductionConfig.enableLogging) {
      debugPrint('❌ System UI configuration failed: $e');
    }
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: ProductionConfig.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          
          debugShowCheckedModeBanner: ProductionConfig.isDebug,
          routes: app_routes.AppRoutes.routes,
          initialRoute: app_routes.AppRoutes.initial,
          
          // Enhanced error handling for unknown routes
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                backgroundColor: AppTheme.primaryBackground,
                appBar: AppBar(
                  title: Text(
                    'Page Not Found',
                    style: AppTheme.darkTheme.textTheme.titleLarge,
                  ),
                  backgroundColor: AppTheme.primaryBackground,
                  elevation: 0,
                ),
                body: Center(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppTheme.error.withAlpha(26),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'error_outline',
                              color: AppTheme.error,
                              size: 48,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Page Not Found',
                          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'The page "${settings.name}" could not be found.',
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            app_routes.AppRoutes.initial,
                            (route) => false,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: AppTheme.primaryAction,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                          ),
                          child: Text(
                            'Go to Home',
                            style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                              color: AppTheme.primaryAction,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}