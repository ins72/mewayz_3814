import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QRCodeModal extends StatefulWidget {
  const QRCodeModal({Key? key}) : super(key: key);

  @override
  State<QRCodeModal> createState() => _QRCodeModalState();
}

class _QRCodeModalState extends State<QRCodeModal> {
  String _selectedStyle = 'classic';
  Color _selectedColor = const Color(0xFF000000);
  String _pageUrl = 'https://yourpage.bio/username';

  final List<Map<String, dynamic>> _qrStyles = [
    {
      'id': 'classic',
      'name': 'Classic',
      'description': 'Traditional square QR code',
    },
    {
      'id': 'rounded',
      'name': 'Rounded',
      'description': 'Rounded corners for modern look',
    },
    {
      'id': 'dots',
      'name': 'Dots',
      'description': 'Circular dots instead of squares',
    },
  ];

  final List<Color> _colorOptions = [
    const Color(0xFF000000),
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFFF59E0B),
  ];

  void _downloadQRCode() {
    // Simulate download process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR Code downloaded successfully!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _shareQRCode() {
    // Simulate share process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR Code shared successfully!'),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 90.w,
        height: 75.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQRCodePreview(),
                    SizedBox(height: 3.h),
                    _buildStyleOptions(),
                    SizedBox(height: 3.h),
                    _buildColorOptions(),
                    SizedBox(height: 3.h),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'qr_code',
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            'QR Code Generator',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodePreview() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryAction,
              borderRadius:
                  BorderRadius.circular(_selectedStyle == 'rounded' ? 16 : 8),
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code_2',
                    color: _selectedColor,
                    size: 80,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'QR Code Preview',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              _pageUrl,
              style: AppTheme.dataTextTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QR Code Style',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        ...(_qrStyles.map((style) => _buildStyleOption(style)).toList()),
      ],
    );
  }

  Widget _buildStyleOption(Map<String, dynamic> style) {
    final isSelected = style['id'] == _selectedStyle;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStyle = style['id'] as String;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withValues(alpha: 0.1)
              : AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : AppTheme.border,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.primaryAction,
                        size: 16,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style['name'] as String,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? AppTheme.accent : AppTheme.primaryText,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    style['description'] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QR Code Color',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          children:
              _colorOptions.map((color) => _buildColorOption(color)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = color == _selectedColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.primaryAction : AppTheme.border,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: color == const Color(0xFF000000)
                      ? AppTheme.primaryAction
                      : AppTheme.primaryBackground,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _downloadQRCode,
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.primaryBackground,
              size: 20,
            ),
            label: const Text('Download QR Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _shareQRCode,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.primaryText,
              size: 20,
            ),
            label: const Text('Share QR Code'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Use this QR code for offline promotion. People can scan it to visit your Link in Bio page directly.',
          style: AppTheme.darkTheme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
