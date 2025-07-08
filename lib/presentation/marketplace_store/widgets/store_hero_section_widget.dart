import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class StoreHeroSectionWidget extends StatelessWidget {
  final Map<String, dynamic> storeData;

  const StoreHeroSectionWidget({
    Key? key,
    required this.storeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Banner Image
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.surface,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: storeData['bannerImage'] ?? '',
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryBackground.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2.h,
                    right: 4.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.primaryText,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Edit Banner',
                            style: AppTheme.darkTheme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Products',
                  '${storeData['totalProducts'] ?? 0}',
                  'inventory_2',
                  AppTheme.accent,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Orders',
                  '${storeData['totalOrders'] ?? 0}',
                  'shopping_bag',
                  AppTheme.success,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Revenue',
                  storeData['revenue'] ?? '\$0',
                  'attach_money',
                  AppTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}