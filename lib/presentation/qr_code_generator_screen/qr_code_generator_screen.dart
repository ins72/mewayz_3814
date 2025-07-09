
import '../../core/app_export.dart';
import './widgets/analytics_integration_widget.dart';
import './widgets/batch_generation_widget.dart';
import './widgets/custom_frame_widget.dart';
import './widgets/download_options_widget.dart';
import './widgets/style_customization_widget.dart';
import './widgets/template_library_widget.dart';
import './widgets/url_input_widget.dart';

class QrCodeGeneratorScreen extends StatefulWidget {
  const QrCodeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeGeneratorScreen> createState() => _QrCodeGeneratorScreenState();
}

class _QrCodeGeneratorScreenState extends State<QrCodeGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedType = 'URL';
  String _generatedUrl = '';
  Color _qrColor = AppTheme.primaryBackground;
  Color _backgroundColor = AppTheme.primaryAction;
  String _selectedTemplate = 'classic';
  double _borderRadius = 0.0;
  double _logoSize = 0.2;
  String _logoUrl = '';
  bool _includeAnalytics = false;
  bool _customFrame = false;
  String _frameStyle = 'rounded';
  
  final List<String> _qrTypes = [
    'URL',
    'Text',
    'Email',
    'Phone',
    'SMS',
    'WiFi',
    'vCard',
    'Event',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _urlController.addListener(_onUrlChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onUrlChanged() {
    setState(() {
      _generatedUrl = _urlController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicTab(),
                _buildStyleTab(),
                _buildAdvancedTab(),
                _buildBatchTab(),
              ])),
        ]),
      bottomNavigationBar: _buildBottomActions());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.primaryText,
          size: 24),
        onPressed: () => Navigator.pop(context)),
      title: Text(
        'QR Code Generator',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryText,
          fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'history',
            color: AppTheme.primaryText,
            size: 24),
          onPressed: () => _showHistory()),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.primaryText,
            size: 24),
          onPressed: () => _showMoreOptions()),
      ]);
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border.withAlpha(26),
            width: 1))),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.accent,
        unselectedLabelColor: AppTheme.secondaryText,
        indicatorColor: AppTheme.accent,
        indicatorWeight: 2,
        labelStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400),
        tabs: const [
          Tab(text: 'Basic'),
          Tab(text: 'Style'),
          Tab(text: 'Advanced'),
          Tab(text: 'Batch'),
        ]));
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QR Type Selection
          _buildTypeSelection(),
          SizedBox(height: 4.h),
          
          // URL Input
          UrlInputWidget(
            controller: _urlController,
            onValidationChanged: (isValid) {
              // Handle validation change
            },
            onChanged: (value) {
              setState(() {
                _generatedUrl = value;
              });
            }),
          SizedBox(height: 4.h),
          
          // QR Code Preview
          // Replace with appropriate widget
          Container(
            child: Text("QR Code Preview"),
          ),
          SizedBox(height: 4.h),
          
          // Analytics Toggle
          _buildAnalyticsToggle(),
        ]));
  }

  Widget _buildStyleTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Style Customization
          StyleCustomizationWidget(
            backgroundColor: _backgroundColor,
            foregroundColor: _qrColor,
            qrSize: 200.0,
            hasLogo: _logoUrl.isNotEmpty,
            errorCorrectionLevel: 'M',
            onBackgroundColorChanged: (color) {
              setState(() {
                _backgroundColor = color;
              });
            },
            onForegroundColorChanged: (color) {
              setState(() {
                _qrColor = color;
              });
            },
            onSizeChanged: (size) {
              // Handle size change
            },
            onLogoToggled: (hasLogo) {
              // Handle logo toggle
            },
            onErrorCorrectionChanged: (level) {
              // Handle error correction change
            }),
          SizedBox(height: 4.h),
          
          // Template Library
          TemplateLibraryWidget(
            selectedTemplate: _selectedTemplate,
            onTemplateSelected: (template) {
              setState(() {
                _selectedTemplate = template;
              });
            }),
        ]));
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Frame
          CustomFrameWidget(
            selectedFrame: _frameStyle,
            callToActionText: "",
            onFrameChanged: (style) {
              setState(() {
                _frameStyle = style;
              });
            },
            onCallToActionChanged: (text) {
              // Handle call to action text change
            }),
          SizedBox(height: 4.h),
          
          // Analytics Integration
          AnalyticsIntegrationWidget(
            qrCodeUrl: _generatedUrl),
          SizedBox(height: 4.h),
          
          // Download Options
          DownloadOptionsWidget(
            onDownload: (format, quality) => _downloadQR(format)),
        ]));
  }

  Widget _buildBatchTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BatchGenerationWidget(
            onBatchGenerate: (urls) => _generateBatch(urls)),
        ]));
  }

  Widget _buildTypeSelection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QR Code Type',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _qrTypes.map((type) {
              final isSelected = _selectedType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = type;
                    _urlController.clear();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.accent.withAlpha(26)
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.accent
                          : AppTheme.border.withAlpha(26),
                      width: 1)),
                  child: Text(
                    type,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected 
                          ? AppTheme.accent
                          : AppTheme.primaryText,
                      fontWeight: isSelected 
                          ? FontWeight.w600
                          : FontWeight.w400))));
            }).toList()),
        ]));
  }

  Widget _buildAnalyticsToggle() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.accent,
            size: 24),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Include Analytics',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w500)),
                Text(
                  'Track scans and user engagement',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText)),
              ])),
          Switch(
            value: _includeAnalytics,
            onChanged: (value) {
              setState(() {
                _includeAnalytics = value;
              });
            },
            activeColor: AppTheme.accent),
        ]));
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.border.withAlpha(26),
            width: 1))),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _generatedUrl.isNotEmpty ? () => _downloadQR('PNG') : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM))),
              child: Text(
                'Download PNG',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryAction,
                  fontWeight: FontWeight.w600)))),
          SizedBox(width: 4.w),
          ElevatedButton(
            onPressed: _generatedUrl.isNotEmpty ? () => _shareQR() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceVariant,
              foregroundColor: AppTheme.primaryText,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM))),
            child: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.primaryText,
              size: 20)),
        ]));
  }

  void _downloadQR(String format) {
    // Implementation for downloading QR code
    Fluttertoast.showToast(
      msg: 'QR Code downloaded as $format',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction);
  }

  void _shareQR() {
    // Implementation for sharing QR code
    Fluttertoast.showToast(
      msg: 'QR Code shared successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction);
  }

  void _generateBatch(List<String> urls) {
    // Implementation for batch generation
    Fluttertoast.showToast(
      msg: 'Batch generation started for ${urls.length} QR codes',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction);
  }

  void _showHistory() {
    // Implementation for showing QR code history
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXl),
          topRight: Radius.circular(AppTheme.radiusXl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'QR Code History',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600)),
            SizedBox(height: 2.h),
            Text(
              'No history available',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText)),
            SizedBox(height: 4.h),
          ])));
  }

  void _showMoreOptions() {
    // Implementation for more options
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXl),
          topRight: Radius.circular(AppTheme.radiusXl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.accent,
                size: 24),
              title: Text(
                'Settings',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              }),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.accent,
                size: 24),
              title: Text(
                'Help & Support',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              }),
            SizedBox(height: 2.h),
          ])));
  }
}