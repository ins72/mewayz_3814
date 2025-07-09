
import '../../core/app_export.dart';
import '../../services/store_data_service.dart';
import '../../services/workspace_service.dart';
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
  
  final StoreDataService _storeService = StoreDataService();
  final WorkspaceService _workspaceService = WorkspaceService();
  
  String? _currentWorkspaceId;
  Map<String, dynamic> _storeData = {};
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic> _storeAnalytics = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStoreData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStoreData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current workspace
      final workspaces = await _workspaceService.getUserWorkspaces();
      if (workspaces.isNotEmpty) {
        _currentWorkspaceId = workspaces.first['id'];
        
        // Load store data
        final storeData = await _storeService.getStoreData(_currentWorkspaceId!);
        final products = await _storeService.getProducts(_currentWorkspaceId!);
        final orders = await _storeService.getOrders(_currentWorkspaceId!);
        final analytics = await _storeService.getStoreAnalytics(_currentWorkspaceId!);
        
        setState(() {
          _storeData = storeData;
          _products = products;
          _orders = orders;
          _storeAnalytics = analytics;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load store data: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadStoreData();
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialogWidget(
        onProductAdded: (product) async {
          if (_currentWorkspaceId != null) {
            final success = await _storeService.createProduct(_currentWorkspaceId!, product);
            if (success) {
              await _refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product added successfully'),
                  backgroundColor: AppTheme.success));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add product'),
                  backgroundColor: AppTheme.error));
            }
          }
        }));
  }

  void _onProductAction(Map<String, dynamic> product, String action) async {
    if (_currentWorkspaceId == null) return;

    switch (action) {
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.surface,
            title: Text(
              'Delete Product',
              style: GoogleFonts.inter(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600)),
            content: Text(
              'Are you sure you want to delete "${product['name']}"?',
              style: GoogleFonts.inter(
                color: AppTheme.secondaryText)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryText))),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error),
                child: Text('Delete')),
            ]));
        
        if (confirmed == true) {
          final success = await _storeService.deleteProduct(_currentWorkspaceId!, product['id']);
          if (success) {
            await _refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product deleted successfully'),
                backgroundColor: AppTheme.success));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete product'),
                backgroundColor: AppTheme.error));
          }
        }
        break;
      case 'edit':
        // Handle product editing
        break;
      case 'duplicate':
        // Handle product duplication
        break;
      case 'toggle_status':
        final newStatus = product['status'] == 'active' ? 'inactive' : 'active';
        final success = await _storeService.updateProduct(_currentWorkspaceId!, product['id'], {
          'status': newStatus,
        });
        if (success) {
          await _refreshData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product status updated'),
              backgroundColor: AppTheme.success));
        }
        break;
    }
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
            size: 24)),
        title: Text(
          'My Store',
          style: AppTheme.darkTheme.textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to store settings
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.primaryText,
              size: 24)),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Products'),
            Tab(text: 'Orders'),
            Tab(text: 'Analytics'),
          ])),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                        StoreHeaderWidget(storeData: _storeData),
                        SizedBox(height: 2.h),
                        StoreHeroSectionWidget(storeData: _storeData),
                        SizedBox(height: 2.h),
                        ProductGridWidget(
                          products: _products.take(4).toList(),
                          isPreview: true,
                          onProductTap: (product) {
                            // Handle product tap
                          },
                          onProductAction: _onProductAction),
                        SizedBox(height: 2.h),
                      ])),
                  // Products Tab
                  ProductGridWidget(
                    products: _products,
                    isPreview: false,
                    onProductTap: (product) {
                      // Handle product tap
                    },
                    onProductAction: _onProductAction),
                  // Orders Tab
                  OrderManagementWidget(
                    orders: _orders,
                    onOrderTap: (order) {
                      // Handle order tap
                    }),
                  // Analytics Tab
                  AnalyticsDashboardWidget(
                    storeData: _storeData,
                    products: _products,
                    orders: _orders),
                ])),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showAddProductDialog,
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: AppTheme.primaryBackground,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryBackground,
                size: 24),
              label: Text(
                'Add Product',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryBackground)))
          : null);
  }
}