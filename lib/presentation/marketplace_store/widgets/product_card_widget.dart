import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final Function(String) onAction;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Status Indicators
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: product['image'] ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Status Indicators
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Row(
                      children: [
                        if (product['isBestseller'] == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: AppTheme.primaryBackground,
                                  size: 12,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Best',
                                  style: AppTheme.darkTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.primaryBackground,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Quick Actions
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: PopupMenuButton<String>(
                      onSelected: onAction,
                      color: AppTheme.surface,
                      icon: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color: AppTheme.primaryText,
                          size: 16,
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.primaryText,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text('Edit',
                                  style:
                                      AppTheme.darkTheme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'content_copy',
                                color: AppTheme.primaryText,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text('Duplicate',
                                  style:
                                      AppTheme.darkTheme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'archive',
                                color: AppTheme.secondaryText,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text('Archive',
                                  style:
                                      AppTheme.darkTheme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'delete',
                                color: AppTheme.error,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Delete',
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Product Name',
                      style: AppTheme.darkTheme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      product['price'] ?? '\$0.00',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    // Stock Status
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(product['status']),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _getStatusText(product['status'], product['stock']),
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getStatusColor(product['status']),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'low_stock':
        return AppTheme.warning;
      case 'out_of_stock':
        return AppTheme.error;
      default:
        return AppTheme.success;
    }
  }

  String _getStatusText(String? status, dynamic stock) {
    switch (status) {
      case 'low_stock':
        return 'Low Stock ($stock left)';
      case 'out_of_stock':
        return 'Out of Stock';
      default:
        return 'In Stock ($stock)';
    }
  }
}
