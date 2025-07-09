import 'package:flutter/foundation.dart';
import 'dart:io' as io;

/// Utility class for platform-specific operations
class PlatformUtils {
  /// Check if running on web platform
  static bool get isWeb => kIsWeb;
  
  /// Check if running on mobile platform
  static bool get isMobile => !kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS);
  
  /// Check if running on desktop platform
  static bool get isDesktop => !kIsWeb && (io.Platform.isWindows || io.Platform.isMacOS || io.Platform.isLinux);
  
  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && io.Platform.isAndroid;
  
  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && io.Platform.isIOS;
  
  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && io.Platform.isWindows;
  
  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && io.Platform.isMacOS;
  
  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && io.Platform.isLinux;
  
  /// Get platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (io.Platform.isAndroid) return 'Android';
    if (io.Platform.isIOS) return 'iOS';
    if (io.Platform.isWindows) return 'Windows';
    if (io.Platform.isMacOS) return 'macOS';
    if (io.Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}