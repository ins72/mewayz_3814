

export 'dart:convert';
export 'dart:math';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/foundation.dart';
export 'package:sizer/sizer.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:fl_chart/fl_chart.dart';
export 'package:dio/dio.dart';

// Core exports
export './analytics_service.dart';
export './api_client.dart';
export './app_constants.dart';
export './accessibility_service.dart';
export './error_handler.dart';
export './notification_service.dart';
export './production_config.dart';
export './security_service.dart';
export './storage_service.dart';
export './supabase_service.dart';
export './button_service.dart' hide HapticFeedbackType;
export './platform_utils.dart';

// Services
export '../services/auth_service.dart';
export '../services/onboarding_service.dart';
export '../services/data_service.dart';

// Theme
export '../theme/app_theme.dart';

// Widgets
export '../widgets/custom_accessibility_widget.dart';
export '../widgets/custom_app_bar_widget.dart';
export '../widgets/custom_bottom_navigation_widget.dart';
export '../widgets/custom_empty_state_widget.dart';
export '../widgets/custom_error_widget.dart';
export '../widgets/custom_form_field_widget.dart';
export '../widgets/custom_icon_widget.dart';
export '../widgets/custom_image_widget.dart';
export '../widgets/custom_loading_widget.dart';
export '../widgets/custom_enhanced_button_widget.dart';

// Routes
export '../routes/app_routes.dart';

// Platform-specific conditional imports
// For dart:io functionality, use conditional imports in individual files:
// 

// Bottom Navigation Item
class BottomNavigationItem {
  final String iconName;
  final String label;
  final bool isActive;

  const BottomNavigationItem({
    required this.iconName,
    required this.label,
    this.isActive = false,
  });
}