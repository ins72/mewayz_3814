import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import './product_card_widget.dart';

class ProductGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool isPreview;
  final Function(Map<String, dynamic>) onProductTap;
  final Function(Map<String, dynamic>, String) onProductAction;

  const ProductGridWidget({
    Key? key,
    required this.products,
    required this.isPreview,
    required this.onProductTap,
    required this.onProductAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return isPreview ? _buildPreviewGrid() : _buildFullGrid();
  }

  Widget _buildPreviewGrid() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Products',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  // Switch to products tab
                },
                child: Text(
                  'View All',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCardWidget(
                product: products[index],
                onTap: () => onProductTap(products[index]),
                onAction: (action) => onProductAction(products[index], action),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFullGrid() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCardWidget(
            product: products[index],
            onTap: () => onProductTap(products[index]),
            onAction: (action) => onProductAction(products[index], action),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'inventory_2',
              color: AppTheme.secondaryText,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Products Yet',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Add your first product to start selling',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                // Add product action
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryBackground,
                size: 20,
              ),
              label: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}