import '../core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await _initializeServices();

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

Future<void> _initializeServices() async {
  try {
    // Initialize Supabase
    SupabaseService();
    
    // Initialize storage service
    final storageService = StorageService();
    await storageService.initialize();
    
    // Initialize API client
    final apiClient = ApiClient();
    apiClient.initialize();
    
    // Initialize analytics service
    final analyticsService = AnalyticsService();
    await analyticsService.initialize();
    
    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();
    
    // Initialize security service
    final securityService = SecurityService();
    await securityService.initialize();
    
    if (ProductionConfig.enableLogging) {
      debugPrint('All services initialized successfully');
    }
  } catch (e) {
    ErrorHandler.handleError('Failed to initialize services: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: ProductionConfig.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
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
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}