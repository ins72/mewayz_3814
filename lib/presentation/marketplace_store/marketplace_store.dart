
import '../../core/app_export.dart';
import './widgets/add_product_dialog_widget.dart';
import './widgets/analytics_dashboard_widget.dart';
import './widgets/order_management_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/store_header_widget.dart';
import './widgets/store_hero_section_widget.dart';

class MarketplaceStore extends StatefulWidget {
  const MarketplaceStore({Key? key}) : super(key: key);

  @override
  State<MarketplaceStore> createState() => _MarketplaceStoreState();
}

class _MarketplaceStoreState extends State<MarketplaceStore>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock store data
  final Map<String, dynamic> storeData = {
    "storeName": "TechHub Electronics",
    "rating": 4.8,
    "isVerified": true,
    "bannerImage":
        "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=300&fit=crop",
    "totalProducts": 156,
    "totalOrders": 2847,
    "revenue": "\$45,230",
    "description":
        "Premium electronics and gadgets for tech enthusiasts worldwide"
  };

  final List<Map<String, dynamic>> products = [
{ "id": 1,
"name": "Wireless Bluetooth Headphones",
"price": "\$89.99",
"image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
"stock": 25,
"status": "active",
"isBestseller": true,
"category": "Electronics" },
{ "id": 2,
"name": "Smart Watch Pro",
"price": "\$299.99",
"image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
"stock": 5,
"status": "low_stock",
"isBestseller": false,
"category": "Wearables" },
{ "id": 3,
"name": "USB-C Hub Adapter",
"price": "\$49.99",
"image": "https://images.unsplash.com/photo-1591488320449-011701bb6704?w=400&h=400&fit=crop",
"stock": 0,
"status": "out_of_stock",
"isBestseller": false,
"category": "Accessories" },
{ "id": 4,
"name": "Portable Power Bank",
"price": "\$39.99",
"image": "https://images.unsplash.com/photo-1609592806596-4d8d2b0e8b8e?w=400&h=400&fit=crop",
"stock": 50,
"status": "active",
"isBestseller": true,
"category": "Accessories" },
{ "id": 5,
"name": "Gaming Mechanical Keyboard",
"price": "\$129.99",
"image": "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=400&h=400&fit=crop",
"stock": 15,
"status": "active",
"isBestseller": false,
"category": "Gaming" },
{ "id": 6,
"name": "4K Webcam",
"price": "\$159.99",
"image": "https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=400&h=400&fit=crop",
"stock": 8,
"status": "low_stock",
"isBestseller": false,
"category": "Electronics" }
];

  final List<Map<String, dynamic>> orders = [
{ "id": "ORD-2024-001",
"customerName": "John Smith",
"items": 3,
"total": "\$179.97",
"status": "pending",
"date": "2024-01-15",
"shippingAddress": "123 Main St, New York, NY 10001" },
{ "id": "ORD-2024-002",
"customerName": "Sarah Johnson",
"items": 1,
"total": "\$299.99",
"status": "processing",
"date": "2024-01-14",
"shippingAddress": "456 Oak Ave, Los Angeles, CA 90210" },
{ "id": "ORD-2024-003",
"customerName": "Mike Davis",
"items": 2,
"total": "\$89.98",
"status": "shipped",
"date": "2024-01-13",
"shippingAddress": "789 Pine St, Chicago, IL 60601" },
{ "id": "ORD-2024-004",
"customerName": "Emily Wilson",
"items": 1,
"total": "\$129.99",
"status": "delivered",
"date": "2024-01-12",
"shippingAddress": "321 Elm St, Houston, TX 77001" }
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialogWidget(
        onProductAdded: (product) {
          setState(() {
            products.add(product);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 24,
          ),
        ),
        title: Text(
          'My Store',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to store settings
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Products'),
            Tab(text: 'Orders'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Overview Tab
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  StoreHeaderWidget(storeData: storeData),
                  SizedBox(height: 2.h),
                  StoreHeroSectionWidget(storeData: storeData),
                  SizedBox(height: 2.h),
                  ProductGridWidget(
                    products: products.take(4).toList(),
                    isPreview: true,
                    onProductTap: (product) {
                      // Handle product tap
                    },
                    onProductAction: (product, action) {
                      // Handle product actions
                    },
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            // Products Tab
            ProductGridWidget(
              products: products,
              isPreview: false,
              onProductTap: (product) {
                // Handle product tap
              },
              onProductAction: (product, action) {
                setState(() {
                  if (action == 'delete') {
                    products.removeWhere((p) => p['id'] == product['id']);
                  }
                });
              },
            ),
            // Orders Tab
            OrderManagementWidget(
              orders: orders,
              onOrderTap: (order) {
                // Handle order tap
              },
            ),
            // Analytics Tab
            AnalyticsDashboardWidget(
              storeData: storeData,
              products: products,
              orders: orders,
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showAddProductDialog,
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: AppTheme.primaryBackground,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryBackground,
                size: 24,
              ),
              label: Text(
                'Add Product',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryBackground,
                ),
              ),
            )
          : null,
    );
  }
}