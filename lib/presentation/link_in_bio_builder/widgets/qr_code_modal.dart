import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QRCodeModal extends StatefulWidget {
  final String url;
  final String title;

  const QRCodeModal({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<QRCodeModal> createState() => _QRCodeModalState();
}

class _QRCodeModalState extends State<QRCodeModal> {
  String _selectedSize = 'Medium';
  String _selectedFormat = 'PNG';
  Color _selectedColor = const Color(0xFF000000);
  Color _selectedBackgroundColor = const Color(0xFFFFFFFF);

  final List<String> _sizes = ['Small', 'Medium', 'Large', 'Extra Large'];
  final List<String> _formats = ['PNG', 'SVG', 'PDF'];

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.success,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('URL copied to clipboard'),
          ],
        ),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _downloadQRCode() {
    // Simulate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'download',
              color: AppTheme.success,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('QR Code downloaded as $_selectedFormat'),
          ],
        ),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _shareQRCode() {
    // Simulate sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.success,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('QR Code shared successfully'),
          ],
        ),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR Code Generator',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                ),
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
            SizedBox(height: 2.h),
            Text(
              'Generate a QR code for your Link in Bio page',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            SizedBox(height: 3.h),

            // QR Code Preview
            Center(
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: _selectedBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Stack(
                  children: [
                    // QR Code pattern simulation
                    Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomPaint(
                        painter: QRCodePainter(
                          color: _selectedColor,
                          backgroundColor: _selectedBackgroundColor,
                        ),
                        size: Size(52.w, 52.w),
                      ),
                    ),
                    // Center logo placeholder
                    Center(
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'link',
                          color: AppTheme.primaryAction,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // URL Display
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Link URL',
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryText,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.url,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _copyToClipboard,
                    icon: CustomIconWidget(
                      iconName: 'content_copy',
                      color: AppTheme.accent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Customization Options
            Text(
              'Customization',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 2.h),

            // Size Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Size',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedSize,
                        onChanged: (value) {
                          setState(() {
                            _selectedSize = value!;
                          });
                        },
                        items: _sizes.map((size) {
                          return DropdownMenuItem(
                            value: size,
                            child: Text(
                              size,
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.primaryBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppTheme.border),
                          ),
                        ),
                        dropdownColor: AppTheme.surface,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Format',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedFormat,
                        onChanged: (value) {
                          setState(() {
                            _selectedFormat = value!;
                          });
                        },
                        items: _formats.map((format) {
                          return DropdownMenuItem(
                            value: format,
                            child: Text(
                              format,
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.primaryBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppTheme.border),
                          ),
                        ),
                        dropdownColor: AppTheme.surface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Color Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR Code Color',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () => _showColorPicker(true),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Center(
                            child: Text(
                              '#${_selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: _selectedColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background Color',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () => _showColorPicker(false),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Center(
                            child: Text(
                              '#${_selectedBackgroundColor.value.toRadixString(16).substring(2).toUpperCase()}',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: _selectedBackgroundColor
                                            .computeLuminance() >
                                        0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareQRCode,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.primaryText,
                      size: 18,
                    ),
                    label: const Text('Share'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _downloadQRCode,
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.primaryAction,
                      size: 18,
                    ),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(bool isQRCodeColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          isQRCodeColor ? 'Select QR Code Color' : 'Select Background Color',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color presets
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                Colors.black,
                Colors.white,
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.pink,
                Colors.teal,
                Colors.indigo,
                Colors.amber,
                Colors.cyan,
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isQRCodeColor) {
                        _selectedColor = color;
                      } else {
                        _selectedBackgroundColor = color;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class QRCodePainter extends CustomPainter {
  final Color color;
  final Color backgroundColor;

  QRCodePainter({
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw a simplified QR code pattern
    final cellSize = size.width / 21; // 21x21 grid for QR code

    // Draw position detection patterns (corners)
    _drawPositionPattern(canvas, paint, 0, 0, cellSize);
    _drawPositionPattern(canvas, paint, 14 * cellSize, 0, cellSize);
    _drawPositionPattern(canvas, paint, 0, 14 * cellSize, cellSize);

    // Draw some random data patterns
    final random = [
      [2, 2],
      [2, 3],
      [2, 4],
      [3, 2],
      [4, 2],
      [4, 3],
      [4, 4],
      [6, 2],
      [6, 3],
      [6, 4],
      [7, 2],
      [8, 2],
      [8, 3],
      [8, 4],
      [2, 6],
      [2, 7],
      [2, 8],
      [3, 6],
      [4, 6],
      [4, 7],
      [4, 8],
      [6, 6],
      [6, 7],
      [6, 8],
      [7, 6],
      [8, 6],
      [8, 7],
      [8, 8],
      [10, 2],
      [10, 3],
      [11, 2],
      [12, 2],
      [12, 3],
      [12, 4],
      [10, 6],
      [10, 7],
      [11, 6],
      [12, 6],
      [12, 7],
      [12, 8],
    ];

    for (final pos in random) {
      canvas.drawRect(
        Rect.fromLTWH(
          pos[0] * cellSize,
          pos[1] * cellSize,
          cellSize,
          cellSize,
        ),
        paint,
      );
    }
  }

  void _drawPositionPattern(
      Canvas canvas, Paint paint, double x, double y, double cellSize) {
    // Outer 7x7 square
    canvas.drawRect(
      Rect.fromLTWH(x, y, 7 * cellSize, 7 * cellSize),
      paint,
    );

    // Inner white space
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize, y + cellSize, 5 * cellSize, 5 * cellSize),
      Paint()..color = backgroundColor,
    );

    // Center 3x3 square
    canvas.drawRect(
      Rect.fromLTWH(
          x + 2 * cellSize, y + 2 * cellSize, 3 * cellSize, 3 * cellSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
