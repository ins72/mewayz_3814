import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderManagementWidget extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final Function(Map<String, dynamic>) onOrderTap;

  const OrderManagementWidget({
    Key? key,
    required this.orders,
    required this.onOrderTap,
  }) : super(key: key);

  @override
  State<OrderManagementWidget> createState() => _OrderManagementWidgetState();
}

class _OrderManagementWidgetState extends State<OrderManagementWidget> {
  String selectedFilter = 'all';

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == 'all') return widget.orders;
    return widget.orders
        .where((order) => order['status'] == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Tabs
        Container(
          margin: EdgeInsets.all(4.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'All Orders'),
                SizedBox(width: 2.w),
                _buildFilterChip('pending', 'Pending'),
                SizedBox(width: 2.w),
                _buildFilterChip('processing', 'Processing'),
                SizedBox(width: 2.w),
                _buildFilterChip('shipped', 'Shipped'),
                SizedBox(width: 2.w),
                _buildFilterChip('delivered', 'Delivered'),
              ],
            ),
          ),
        ),
        // Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(filteredOrders[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['id'] ?? 'Order ID',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      _getStatusColor(order['status']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(order['status']),
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(order['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.secondaryText,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  order['customerName'] ?? 'Customer Name',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.secondaryText,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                order['date'] ?? 'Date',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_bag',
                    color: AppTheme.secondaryText,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${order['items'] ?? 0} items',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Text(
                order['total'] ?? '\$0.00',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.onOrderTap(order),
                  child: Text('View Details'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Update order status
                  },
                  child: Text(_getActionText(order['status'])),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'shopping_bag',
            color: AppTheme.secondaryText,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Orders Found',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            selectedFilter == 'all'
                ? 'You haven\'t received any orders yet'
                : 'No ${selectedFilter} orders found',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return AppTheme.warning;
      case 'processing':
        return AppTheme.accent;
      case 'shipped':
        return AppTheme.success;
      case 'delivered':
        return AppTheme.success;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  String _getActionText(String? status) {
    switch (status) {
      case 'pending':
        return 'Process';
      case 'processing':
        return 'Ship';
      case 'shipped':
        return 'Track';
      case 'delivered':
        return 'Complete';
      default:
        return 'Update';
    }
  }
}
