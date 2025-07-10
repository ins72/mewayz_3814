import '../../../core/app_export.dart';

class ComponentRendererWidget extends StatelessWidget {
  final Map<String, dynamic> component;
  final Map<String, dynamic> themeSettings;
  final bool isEditMode;

  const ComponentRendererWidget({
    Key? key,
    required this.component,
    required this.themeSettings,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final componentType = component['component_type'] as String;
    final componentData = component['component_data'] as Map<String, dynamic>;
    final styleSettings = component['style_settings'] as Map<String, dynamic>? ?? {};

    switch (componentType) {
      case 'link_button':
        return _buildLinkButton(componentData, styleSettings);
      case 'text_block':
        return _buildTextBlock(componentData, styleSettings);
      case 'image':
        return _buildImage(componentData, styleSettings);
      case 'social_links':
        return _buildSocialLinks(componentData, styleSettings);
      case 'divider':
        return _buildDivider(componentData, styleSettings);
      case 'spacer':
        return _buildSpacer(componentData);
      default:
        return _buildUnsupportedComponent(componentType);
    }
  }

  Widget _buildLinkButton(Map<String, dynamic> data, Map<String, dynamic> style) {
    final title = data['title'] as String? ?? 'Link';
    final description = data['description'] as String? ?? '';
    final url = data['url'] as String? ?? '';
    
    final buttonStyle = style['button_style'] as String? ?? themeSettings['button_style'] ?? 'solid';
    final backgroundColor = _parseColor(style['background_color'] ?? themeSettings['accent_color'] ?? '#007bff');
    final textColor = _parseColor(style['text_color'] ?? '#ffffff');
    final borderRadius = (style['border_radius'] as num?)?.toDouble() ?? themeSettings['border_radius']?.toDouble() ?? 8.0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEditMode ? null : () => _launchUrl(url),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: buttonStyle == 'solid' ? backgroundColor : Colors.transparent,
              border: buttonStyle == 'outline' ? Border.all(color: backgroundColor, width: 2) : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: buttonStyle == 'solid' ? textColor : backgroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: (buttonStyle == 'solid' ? textColor : backgroundColor).withAlpha(204),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextBlock(Map<String, dynamic> data, Map<String, dynamic> style) {
    final text = data['text'] as String? ?? 'Text';
    final fontSize = (data['font_size'] as num?)?.toDouble() ?? 16.0;
    final alignment = data['alignment'] as String? ?? 'center';
    final textColor = _parseColor(style['text_color'] ?? themeSettings['text_color'] ?? '#333333');

    TextAlign textAlign;
    switch (alignment) {
      case 'left':
        textAlign = TextAlign.left;
        break;
      case 'right':
        textAlign = TextAlign.right;
        break;
      case 'center':
      default:
        textAlign = TextAlign.center;
        break;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildImage(Map<String, dynamic> data, Map<String, dynamic> style) {
    final imageUrl = data['url'] as String? ?? '';
    final altText = data['alt_text'] as String? ?? '';
    final linkUrl = data['link_url'] as String? ?? '';
    final borderRadius = (style['border_radius'] as num?)?.toDouble() ?? 8.0;

    Widget imageWidget = Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 48),
                  ),
                ),
              )
            : Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image, size: 48),
                ),
              ),
      ),
    );

    if (linkUrl.isNotEmpty && !isEditMode) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchUrl(linkUrl),
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }

  Widget _buildSocialLinks(Map<String, dynamic> data, Map<String, dynamic> style) {
    final links = data['links'] as List<dynamic>? ?? [];
    final layout = style['layout'] as String? ?? 'grid';
    final iconSize = style['icon_size'] as String? ?? 'medium';
    final showLabels = style['show_labels'] as bool? ?? true;

    double iconSizeValue;
    switch (iconSize) {
      case 'small':
        iconSizeValue = 24;
        break;
      case 'large':
        iconSizeValue = 48;
        break;
      case 'medium':
      default:
        iconSizeValue = 32;
        break;
    }

    if (layout == 'grid') {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: links.map((link) => _buildSocialIcon(
            link as Map<String, dynamic>,
            iconSizeValue,
            showLabels,
          )).toList(),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: links.map((link) => Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: _buildSocialIcon(
              link as Map<String, dynamic>,
              iconSizeValue,
              showLabels,
            ),
          )).toList(),
        ),
      );
    }
  }

  Widget _buildSocialIcon(Map<String, dynamic> link, double iconSize, bool showLabels) {
    final platform = link['platform'] as String? ?? '';
    final url = link['url'] as String? ?? '';
    final username = link['username'] as String? ?? '';

    Color platformColor;
    IconData platformIcon;

    switch (platform.toLowerCase()) {
      case 'instagram':
        platformColor = const Color(0xFFE4405F);
        platformIcon = Icons.camera_alt;
        break;
      case 'twitter':
        platformColor = const Color(0xFF1DA1F2);
        platformIcon = Icons.flutter_dash;
        break;
      case 'facebook':
        platformColor = const Color(0xFF1877F2);
        platformIcon = Icons.facebook;
        break;
      case 'linkedin':
        platformColor = const Color(0xFF0A66C2);
        platformIcon = Icons.work;
        break;
      case 'youtube':
        platformColor = const Color(0xFFFF0000);
        platformIcon = Icons.play_circle_fill;
        break;
      case 'tiktok':
        platformColor = const Color(0xFF000000);
        platformIcon = Icons.music_note;
        break;
      default:
        platformColor = Colors.grey;
        platformIcon = Icons.link;
    }

    Widget iconWidget = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEditMode ? null : () => _launchUrl(url),
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: platformColor,
            borderRadius: BorderRadius.circular(iconSize / 2),
          ),
          child: Icon(
            platformIcon,
            color: Colors.white,
            size: iconSize * 0.6,
          ),
        ),
      ),
    );

    if (showLabels && username.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 4),
          Text(
            username,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _parseColor(themeSettings['text_color'] ?? '#333333'),
            ),
          ),
        ],
      );
    }

    return iconWidget;
  }

  Widget _buildDivider(Map<String, dynamic> data, Map<String, dynamic> style) {
    final dividerStyle = data['style'] as String? ?? 'solid';
    final color = _parseColor(data['color'] ?? '#e0e0e0');
    final thickness = (data['thickness'] as num?)?.toDouble() ?? 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: dividerStyle == 'dashed'
          ? CustomPaint(
              size: Size(double.infinity, thickness),
              painter: DashedLinePainter(color: color, thickness: thickness),
            )
          : Divider(
              color: color,
              thickness: thickness,
              height: thickness,
            ),
    );
  }

  Widget _buildSpacer(Map<String, dynamic> data) {
    final height = (data['height'] as num?)?.toDouble() ?? 20.0;
    return SizedBox(height: height);
  }

  Widget _buildUnsupportedComponent(String componentType) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Unsupported component: $componentType',
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }

  void _launchUrl(String url) {
    // In a real app, implement URL launching
    debugPrint('Launching URL: $url');
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;

  DashedLinePainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}