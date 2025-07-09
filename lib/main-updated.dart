import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'dart:async';
import 'custom_inspector.dart';
import 'dart:html' as html;
import 'dart:convert';

import '../core/app_export.dart';
import './routes/app_routes.dart' as app_routes;

var backendURL = "https://mewayz2556back.builtwithrocket.new/log-error";

void main() async {
  FlutterError.onError = (details) {
    _sendOverflowError(details);
  };
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
        navigatorObservers: [routeObserver],
        title: ProductionConfig.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return CustomWidgetInspector(
             child: TrackingWidget(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
      ),
              child: child!,
            ) // Preserve original MediaQuery content
          )
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
}final ValueNotifier<String> currentPageNotifier = ValueNotifier<String>('');

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
          void _updateCurrentPage(Route<dynamic>? route) {
            if (route is PageRoute) {
              currentPageNotifier.value = route.settings.name ?? '';
            }
          }

          @override
          void didPush(Route route, Route? previousRoute) {
            super.didPush(route, previousRoute);
            _updateCurrentPage(route);
          }

          @override
          void didPop(Route route, Route? previousRoute) {
            super.didPop(route, previousRoute);
            _updateCurrentPage(previousRoute);
          }

          @override
          void didReplace({Route? newRoute, Route? oldRoute}) {
            super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
            _updateCurrentPage(newRoute);
          }
        }
        final MyRouteObserver routeObserver = MyRouteObserver();



    void _sendOverflowError(FlutterErrorDetails details) {
      try {
        final errorMessage = details.exception.toString();
        final exceptionType = details.exception.runtimeType.toString();

        String location = 'Unknown';
        final locationMatch = RegExp(r'file:///.*\.dart').firstMatch(details.toString());
        if (locationMatch != null) {
          location = locationMatch.group(0)?.replaceAll("file://", '') ?? 'Unknown';
        }
        String errorType = "RUNTIME_ERROR";
        if(errorMessage.contains('overflowed by') || errorMessage.contains('RenderFlex overflowed')) {
          errorType = 'OVERFLOW_ERROR';
        }
        final payload = {
          'errorType': errorType,
          'exceptionType': exceptionType,
          'message': errorMessage,
          'location': location,
          'timestamp': DateTime.now().toIso8601String(),
        };
        final jsonData = jsonEncode(payload);
        final request = html.HttpRequest();
        request.open('POST', backendURL, async: true);
        request.setRequestHeader('Content-Type', 'application/json');
        request.onReadyStateChange.listen((_) {
          if (request.readyState == html.HttpRequest.DONE) {
            if (request.status == 200) {
              print('Successfully reported error');
            } else {
              print('Error reporting overflow');
            }
          }
        });
        request.onError.listen((event) {
          print('Failed to send overflow report');
        });
        request.send(jsonData);
      } catch (e) {
        print('Exception while reporting overflow error: $e');
      }
    }
    class TrackingWidget extends StatefulWidget {
  final Widget child;

  const TrackingWidget({super.key, required this.child});

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  Timer? _debounce;
  RenderObject? _selectedRenderObject;
  Element? _selectedElement;
  final GlobalKey _childKey = GlobalKey();
  Timer? _scrollDebounce;
  String currentPage = '';

  @override
  void initState() {
    super.initState();
    currentPage = currentPageNotifier.value;
    currentPageNotifier.addListener(_updateCurrentPage);
  }

  void _updateCurrentPage() {
    setState(() {
      currentPage = currentPageNotifier.value;
    });
  }

    String findNearestKnownWidget(Element? element) {
    if (element == null) return 'unknown';

    String? foundWidget;

    // Helper function to identify widget type
    String? identifyWidget(Widget widget) {
      if (widget is Text) return 'Text';
      if (widget is Icon) return 'Icon';
      if (widget is ElevatedButton) return 'ElevatedButton';
      if (widget is TextButton) return 'TextButton';
      if (widget is OutlinedButton) return 'OutlinedButton';
      if (widget is FloatingActionButton) return 'FloatingActionButton';
      if (widget is Checkbox) return 'Checkbox';
      if (widget is Radio) return 'Radio';
      if (widget is SwitchListTile) return 'SwitchListTile';
      if (widget is RadioListTile) return 'RadioListTile';
      if (widget is Switch) return 'Switch';
      if (widget is ToggleButtons) return 'ToggleButtons';
      if (widget is Slider) return 'Slider';
      if (widget is RangeSlider) return 'RangeSlider';
      if (widget is Image) return 'Image';
      if (widget is Placeholder) return 'Placeholder';
      if (widget is FileImage) return 'FileImage';
      if (widget is NetworkImage) return 'NetworkImage';
      if (widget is AssetImage) return 'AssetImage';
      if (widget is ListTile) return 'ListTile';
      if (widget is AppBar) return 'AppBar';
      if (widget is BottomNavigationBar) return 'BottomNavigationBar';
      if (widget is Drawer) return 'Drawer';
      if (widget is Card) return 'Card';
      if (widget is Chip) return 'Chip';
      if (widget is ActionChip) return 'ActionChip';
      if (widget is InputChip) return 'InputChip';
      if (widget is ChoiceChip) return 'ChoiceChip';
      if (widget is SnackBar) return 'SnackBar';
      if (widget is Banner) return 'Banner';
      if (widget is ProgressIndicator) return 'ProgressIndicator';
      if (widget is CircularProgressIndicator)
        return 'CircularProgressIndicator';
      if (widget is LinearProgressIndicator) return 'LinearProgressIndicator';
      if (widget is DropdownButton) return 'DropdownButton';
      if (widget is PopupMenuButton) return 'PopupMenuButton';
      if (widget is TextField) return 'TextField';
      if (widget is TextFormField) return 'TextFormField';
      if (widget is IconButton) return 'IconButton';
      if (widget is Form) return 'Form';
      if (widget is Container) return 'Container';
      if (widget is Row) return 'Row';
      if (widget is Column) return 'Column';
      if (widget is Stack) return 'Stack';
      if (widget is Wrap) return 'Wrap';
      if (widget is ListView) return 'ListView';
      if (widget is GridView) return 'GridView';
      if (widget is SingleChildScrollView) return 'SingleChildScrollView';
      if (widget is SizedBox) return 'SizedBox';
      if (widget is Padding) return 'Padding';
      if (widget is Tooltip) return 'Tooltip';
      if (widget is SliverAppBar) return 'SliverAppBar';
      if (widget is SliverList) return 'SliverList';
      if (widget is SliverGrid) return 'SliverGrid';
      if (widget is SliverToBoxAdapter) return 'SliverToBoxAdapter';
      if (widget is SliverFillRemaining) return 'SliverFillRemaining';
      if (widget is SliverPadding) return 'SliverPadding';
      if (widget is SliverFixedExtentList) return 'SliverFixedExtentList';
      if (widget is SliverFillViewport) return 'SliverFillViewport';
      if (widget is SliverPersistentHeader) return 'SliverPersistentHeader';
      return null;
    }

    // Check current element
    foundWidget = identifyWidget(element.widget);
    if (foundWidget != null) return foundWidget;

    // Traverse ancestors
    element.visitAncestorElements((ancestor) {
      foundWidget = identifyWidget(ancestor.widget);
      return foundWidget == null; // continue if not found
    });

    if (foundWidget != null) return foundWidget!;

    // Traverse descendants
    void visitDescendants(Element child) {
      if (foundWidget != null) return;
      foundWidget = identifyWidget(child.widget);
      if (foundWidget == null) {
        child.visitChildren(visitDescendants);
      }
    }

    element.visitChildren(visitDescendants);

    return foundWidget ?? 'unknown';
  }

  void trackInteraction(String eventType, PointerEvent? event) {
    try {
      RenderBox? renderBox;
      if (_selectedRenderObject is RenderBox) {
        renderBox = _selectedRenderObject as RenderBox;
      } else {
        renderBox = null;
      }

      final offset = renderBox?.localToGlobal(Offset.zero);
      final size = renderBox?.size;

      final mousePosition = event?.position;

      final scrollPosition = _getScrollPosition(_selectedRenderObject);

      final interactionData = {
        'eventType': eventType,
        'timestamp': DateTime.now().toIso8601String(),
        'element': {
          'tag': findNearestKnownWidget(_selectedElement),
          'id': _selectedElement?.widget.key?.toString() ??
              widget.child.key?.toString(),
          'position': offset != null
              ? {
            'x': offset.dx.round(),
            'y': offset.dy.round(),
            'width': size?.width.round(),
            'height': size?.height.round(),
          }
              : null,
          'viewport': {
            'width': MediaQuery.of(context).size.width.round(),
            'height': MediaQuery.of(context).size.height.round(),
          },
          'scroll': {
            'x': scrollPosition.dx.round(),
            'y': scrollPosition.dy.round(),
          },
          'mouse': mousePosition != null
              ? {
            'viewport': {
              'x': mousePosition.dx.round(),
              'y': mousePosition.dy.round(),
            },
            'page': {
              'x': (mousePosition.dx + scrollPosition.dx).round(),
              'y': (mousePosition.dy + scrollPosition.dy).round(),
            },
            'element': offset != null
                ? {
              'x': (mousePosition.dx - offset.dx).round(),
              'y': (mousePosition.dy - offset.dy).round(),
            }
                : null,
          }
              : null,
        },
        'page': '/#$currentPage',
      };

      web.window.parentCrossOrigin?.postMessage(
          {
            'type': 'USER_INTERACTION',
            'payload': interactionData,
          }.jsify(),
          '*'.toJS);

      // print('Interaction Data: $interactionData');
    } catch (error) {
      print('Error tracking interaction flutter: $error');
    }
  }

  Offset _getScrollPosition(RenderObject? renderObject) {
    if (renderObject == null) return Offset.zero;

    final element = _findElementForRenderObject(renderObject);
    if (element == null) return Offset.zero;

    final scrollableState = Scrollable.maybeOf(element);
    if (scrollableState != null) {
      final position = scrollableState.position;
      return Offset(position.pixels, position.pixels);
    }

    // Default to zero if not scrollable
    return Offset.zero;
  }

  void _debouncedMouseMove(PointerHoverEvent event) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 10), () {
      _onHover(event);
      trackInteraction('mousemove', event);
    });
  }

  void _onScroll(PointerSignalEvent event) {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
      trackInteraction('scrollend', event);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    currentPageNotifier.removeListener(_updateCurrentPage);
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    final RenderObject? userRender =
    _childKey.currentContext?.findRenderObject();
    if (userRender == null) return;

    final RenderObject? target =
    _findRenderObjectAtPosition(event.position, userRender);

    if (target != null && target != userRender) {
      if (_selectedRenderObject != target) {
        final Element? element = _findElementForRenderObject(target);
        setState(() {
          _selectedRenderObject = target;
          _selectedElement = element;
        });
      }
    } else if (_selectedRenderObject != null) {
      setState(() {
        _selectedRenderObject = null;
        _selectedElement = null;
      });
    }
  }

  RenderObject? _findRenderObjectAtPosition(
      Offset position, RenderObject root) {
    final List<RenderObject> hits = <RenderObject>[];
    _hitTestHelper(hits, position, root, root.getTransformTo(null));
    if (hits.isEmpty) return null;
    hits.sort((a, b) {
      final sizeA = a.semanticBounds.size;
      final sizeB = b.semanticBounds.size;
      return (sizeA.width * sizeA.height).compareTo(sizeB.width * sizeB.height);
    });
    return hits.first;
  }

  bool _hitTestHelper(List<RenderObject> hits, Offset position,
      RenderObject object, Matrix4 transform) {
    bool hit = false;
    final Matrix4? inverse = Matrix4.tryInvert(transform);
    if (inverse == null) return false;
    final Offset localPosition = MatrixUtils.transformPoint(inverse, position);
    final List<DiagnosticsNode> children = object.debugDescribeChildren();
    for (int i = children.length - 1; i >= 0; i--) {
      final DiagnosticsNode diagnostics = children[i];
      if (diagnostics.style == DiagnosticsTreeStyle.offstage ||
          diagnostics.value is! RenderObject) continue;
      final RenderObject child = diagnostics.value! as RenderObject;
      final Rect? paintClip = object.describeApproximatePaintClip(child);
      if (paintClip != null && !paintClip.contains(localPosition)) continue;
      final Matrix4 childTransform = transform.clone();
      object.applyPaintTransform(child, childTransform);
      if (_hitTestHelper(hits, position, child, childTransform)) hit = true;
    }
    final Rect bounds = object.semanticBounds;
    if (bounds.contains(localPosition)) {
      hit = true;
      hits.add(object);
    }
    return hit;
  }

  Element? _findElementForRenderObject(RenderObject renderObject) {
    Element? result;
    void visitor(Element element) {
      if (element.renderObject == renderObject) {
        result = element;
        return;
      }
      element.visitChildren(visitor);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(visitor);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: _debouncedMouseMove,
      onPointerDown: (event) => trackInteraction('click', event),
      onPointerSignal: (event) => _onScroll(event),
      onPointerMove: (event) => trackInteraction('touchmove', event),
      onPointerUp: (event) => trackInteraction('touchend', event),
      child: MouseRegion(
        onEnter: (event) => trackInteraction('mouseenter', event),
        onExit: (event) => trackInteraction('mouseleave', event),
        child: GestureDetector(
          onDoubleTap: () => trackInteraction('dblclick', null),
          onTap: () => trackInteraction('click', null),
          onPanStart: (_) => trackInteraction('touchstart', null),
          onPanUpdate: (_) => trackInteraction('touchmove', null),
          onPanEnd: (_) => trackInteraction('touchend', null),
          child: Focus(
            onKeyEvent: (_, event) {
              if(event is KeyDownEvent){
                trackInteraction('keydown', null);
              }
              return KeyEventResult.ignored;
            },
            key: _childKey,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

