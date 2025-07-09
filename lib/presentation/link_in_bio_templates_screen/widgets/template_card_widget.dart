import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import './template_gallery_widget.dart';

class TemplateCardWidget extends StatefulWidget {
  final TemplateData template;
  final VoidCallback onPreview;
  final VoidCallback onUse;
  final VoidCallback onCustomize;
  final VoidCallback onAnalytics;

  const TemplateCardWidget({
    Key? key,
    required this.template,
    required this.onPreview,
    required this.onUse,
    required this.onCustomize,
    required this.onAnalytics,
  }) : super(key: key);

  @override
  State<TemplateCardWidget> createState() => _TemplateCardWidgetState();
}

class _TemplateCardWidgetState extends State<TemplateCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPreview,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppTheme.accent : AppTheme.border,
              width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview image with overlay
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CustomImageWidget(
                        imageUrl: widget.template.imageUrl,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover)),
                    
                    // Hover overlay
                    if (_isHovered)
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBackground.withAlpha(204),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildActionButton(
                                icon: Icons.visibility,
                                label: 'Preview',
                                onTap: widget.onPreview),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                icon: Icons.palette,
                                label: 'Customize',
                                onTap: widget.onCustomize),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                icon: Icons.download,
                                label: 'Use Template',
                                onTap: widget.onUse,
                                isPrimary: true),
                            ]))),
                    
                    // Premium badge
                    if (widget.template.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.warning,
                            borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            'PRO',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primaryBackground,
                              fontWeight: FontWeight.bold)))),
                    
                    // Popular badge
                    if (widget.template.isPopular)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 12,
                                color: AppTheme.primaryText),
                              const SizedBox(width: 2),
                              Text(
                                'Popular',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.primaryText,
                                  fontWeight: FontWeight.w500)),
                            ]))),
                    
                    // Favorite button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Handle favorite toggle
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBackground.withAlpha(204),
                            borderRadius: BorderRadius.circular(6)),
                          child: Icon(
                            widget.template.isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: widget.template.isFavorite ? AppTheme.error : AppTheme.primaryText)))),
                  ])),
              
              // Template info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and category
                      Text(
                        widget.template.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        widget.template.category,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.secondaryText)),
                      
                      const Spacer(),
                      
                      // Rating and usage
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppTheme.warning),
                          const SizedBox(width: 4),
                          Text(
                            widget.template.rating.toString(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.download,
                            size: 14,
                            color: AppTheme.secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            _formatUsageCount(widget.template.usageCount),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.secondaryText)),
                        ]),
                    ]))),
            ]))));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryAction : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: isPrimary ? null : Border.all(color: AppTheme.border)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isPrimary ? AppTheme.primaryBackground : AppTheme.primaryText),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isPrimary ? AppTheme.primaryBackground : AppTheme.primaryText,
                fontWeight: FontWeight.w500)),
          ])));
  }

  String _formatUsageCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}