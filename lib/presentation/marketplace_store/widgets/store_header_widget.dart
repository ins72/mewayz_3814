import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class StoreHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> storeData;

  const StoreHeaderWidget({
    Key? key,
    required this.storeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            storeData['storeName'] ?? 'Store Name',
                            style: AppTheme.darkTheme.textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (storeData['isVerified'] == true) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.accent,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.warning,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${storeData['rating'] ?? 0.0}',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryText,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '(2,847 reviews)',
                          style: AppTheme.darkTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle edit store
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surface,
                  foregroundColor: AppTheme.primaryText,
                  side: BorderSide(color: AppTheme.border),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  'Edit Store',
                  style: AppTheme.darkTheme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            storeData['description'] ?? 'Store description',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}