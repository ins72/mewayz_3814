import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../workspace_settings_screen/widgets/integrations_settings_widget.dart';
import './widgets/analytics_integration_widget.dart';
import './widgets/batch_generation_widget.dart';
import './widgets/custom_frame_widget.dart';
import './widgets/download_options_widget.dart';
import './widgets/qr_code_preview_widget.dart';
import './widgets/style_customization_widget.dart';
import './widgets/template_library_widget.dart';
import './widgets/url_input_widget.dart';
import 'widgets/analytics_integration_widget.dart';
import 'widgets/batch_generation_widget.dart';
import 'widgets/custom_frame_widget.dart';
import 'widgets/download_options_widget.dart';
import 'widgets/qr_code_preview_widget.dart';
import 'widgets/style_customization_widget.dart';
import 'widgets/template_library_widget.dart';
import 'widgets/url_input_widget.dart';

class QRCodeGeneratorScreen extends StatefulWidget {
  const QRCodeGeneratorScreen({super.key});

  @override
  State<QRCodeGeneratorScreen> createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  final TextEditingController _urlController = TextEditingController();
  String selectedTemplate = 'basic';
  Color foregroundColor = AppTheme.primaryBackground;
  Color backgroundColor = AppTheme.primaryAction;
  double qrSize = 200;
  String errorCorrectionLevel = 'M';
  bool hasLogo = false;
  String selectedFrame = 'none';
  String callToActionText = '';

  @override
  void initState() {
    super.initState();
    _urlController.text = 'https://mewayz.com/bio/username';
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        title: Text(
          'QR Code Generator',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showDownloadOptions(),
            icon: Icon(
              Icons.download_rounded,
              color: AppTheme.primaryText,
              size: 24.sp)),
          IconButton(
            onPressed: () => _shareQRCode(),
            icon: Icon(
              Icons.share_rounded,
              color: AppTheme.primaryText,
              size: 24.sp)),
        ]),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URL Input Section
              UrlInputWidget(
                controller: _urlController,
                onChanged: (value) {
                  setState(() {
                    // Trigger QR code regeneration
                  });
                },
                onValidationChanged: (isValid) {
                  // Handle validation state
                }),
              SizedBox(height: 20.h),

              // QR Code Preview
              QRCodePreviewWidget(
                url: _urlController.text,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                size: qrSize,
                hasLogo: hasLogo,
                selectedFrame: selectedFrame,
                callToActionText: callToActionText),
              SizedBox(height: 24.h),

              // Style Customization
              StyleCustomizationWidget(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                qrSize: qrSize,
                errorCorrectionLevel: errorCorrectionLevel,
                hasLogo: hasLogo,
                onForegroundColorChanged: (color) {
                  setState(() {
                    foregroundColor = color;
                  });
                },
                onBackgroundColorChanged: (color) {
                  setState(() {
                    backgroundColor = color;
                  });
                },
                onSizeChanged: (size) {
                  setState(() {
                    qrSize = size;
                  });
                },
                onErrorCorrectionChanged: (level) {
                  setState(() {
                    errorCorrectionLevel = level;
                  });
                },
                onLogoToggled: (hasLogo) {
                  setState(() {
                    this.hasLogo = hasLogo;
                  });
                }),
              SizedBox(height: 24.h),

              // Custom Frame Options
              CustomFrameWidget(
                selectedFrame: selectedFrame,
                callToActionText: callToActionText,
                onFrameChanged: (frame) {
                  setState(() {
                    selectedFrame = frame;
                  });
                },
                onCallToActionChanged: (text) {
                  setState(() {
                    callToActionText = text;
                  });
                }),
              SizedBox(height: 24.h),

              // Template Library
              TemplateLibraryWidget(
                selectedTemplate: selectedTemplate,
                onTemplateSelected: (template) {
                  setState(() {
                    selectedTemplate = template;
                    _applyTemplate(template);
                  });
                }),
              SizedBox(height: 24.h),

              // Batch Generation
              BatchGenerationWidget(
                onBatchGenerate: (urls) {
                  _generateBatchQRCodes(urls);
                }),
              SizedBox(height: 24.h),

              // Analytics Integration
              AnalyticsIntegrationWidget(
                qrCodeUrl: _urlController.text),
              SizedBox(height: 80.h),
            ]))));
  }

  void _applyTemplate(String template) {
    switch (template) {
      case 'business':
        foregroundColor = AppTheme.primaryBackground;
        backgroundColor = AppTheme.primaryAction;
        selectedFrame = 'business';
        callToActionText = 'Scan for Business Info';
        break;
      case 'social':
        foregroundColor = AppTheme.accent;
        backgroundColor = AppTheme.primaryAction;
        selectedFrame = 'social';
        callToActionText = 'Follow Us';
        break;
      case 'event':
        foregroundColor = AppTheme.warning;
        backgroundColor = AppTheme.primaryAction;
        selectedFrame = 'event';
        callToActionText = 'Event Details';
        break;
      case 'marketing':
        foregroundColor = AppTheme.error;
        backgroundColor = AppTheme.primaryAction;
        selectedFrame = 'marketing';
        callToActionText = 'Special Offer';
        break;
      default:
        foregroundColor = AppTheme.primaryBackground;
        backgroundColor = AppTheme.primaryAction;
        selectedFrame = 'none';
        callToActionText = '';
    }
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
      builder: (context) => DownloadOptionsWidget(
        onDownload: (format, resolution) {
          _downloadQRCode(format, resolution);
        })
    );
  }

  Future<void> _downloadQRCode(String format, int resolution) async {
    try {
      // Simulate download process
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'QR Code downloaded successfully in $format format',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.success.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Download failed. Please try again.',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.error.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    }
  }

  void _shareQRCode() {
    // Copy QR code data to clipboard
    Clipboard.setData(ClipboardData(text: _urlController.text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'QR code URL copied to clipboard',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.accent.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder()));
  }

  void _generateBatchQRCodes(List<String> urls) {
    // Implement batch QR code generation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Generating ${urls.length} QR codes...',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.accent.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder()));
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Trigger rebuild to refresh QR code
    });
  }
}