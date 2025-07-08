import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AddProductDialogWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductAdded;

  const AddProductDialogWidget({
    Key? key,
    required this.onProductAdded,
  }) : super(key: key);

  @override
  State<AddProductDialogWidget> createState() => _AddProductDialogWidgetState();
}

class _AddProductDialogWidgetState extends State<AddProductDialogWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String selectedCategory = 'Electronics';
  List<String> productImages = [];
  bool isDigitalProduct = false;

  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Beauty',
    'Toys',
    'Automotive',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_pageController.page! < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _previousStep() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _addProduct() {
    final newProduct = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "name": _nameController.text,
      "description": _descriptionController.text,
      "price": "\$${_priceController.text}",
      "image": productImages.isNotEmpty
          ? productImages.first
          : "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
      "stock": int.tryParse(_stockController.text) ?? 0,
      "status": "active",
      "isBestseller": false,
      "category": selectedCategory,
      "isDigital": isDigitalProduct,
    };

    widget.onProductAdded(newProduct);
    Navigator.pop(context);
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
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add New Product',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
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
            // Progress Indicator
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Basic Info'),
                Tab(text: 'Images'),
                Tab(text: 'Variants'),
                Tab(text: 'Inventory'),
              ],
            ),
            SizedBox(height: 2.h),
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                children: [
                  _buildBasicInfoStep(),
                  _buildImagesStep(),
                  _buildVariantsStep(),
                  _buildInventoryStep(),
                ],
              ),
            ),
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _tabController.index > 0 ? _previousStep : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _tabController.index < 3 ? _nextStep : _addProduct,
                  child:
                      Text(_tabController.index < 3 ? 'Next' : 'Add Product'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Information',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              hintText: 'Enter product name',
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter product description',
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price',
              hintText: '0.00',
              prefixText: '\$ ',
            ),
          ),
          SizedBox(height: 2.h),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
            dropdownColor: AppTheme.surface,
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Checkbox(
                value: isDigitalProduct,
                onChanged: (value) {
                  setState(() {
                    isDigitalProduct = value!;
                  });
                },
              ),
              Text(
                'Digital Product',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppTheme.border, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'add_photo_alternate',
                color: AppTheme.secondaryText,
                size: 48,
              ),
              SizedBox(height: 1.h),
              Text(
                'Tap to add images',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Support JPG, PNG up to 10MB',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        if (productImages.isNotEmpty) ...[
          Text(
            'Selected Images',
            style: AppTheme.darkTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 10.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  width: 10.h,
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: productImages[index],
                      width: 10.h,
                      height: 10.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVariantsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Variants',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.secondaryText,
                size: 48,
              ),
              SizedBox(height: 1.h),
              Text(
                'Add Variants',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Size, Color, Material, etc.',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              OutlinedButton(
                onPressed: () {
                  // Add variant logic
                },
                child: Text('Add Variant'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory & Shipping',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock Quantity',
              hintText: 'Enter available quantity',
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            decoration: const InputDecoration(
              labelText: 'SKU (Optional)',
              hintText: 'Enter product SKU',
            ),
          ),
          SizedBox(height: 2.h),
          if (!isDigitalProduct) ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'Enter product weight',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Dimensions (L x W x H)',
                hintText: 'Enter dimensions in cm',
              ),
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (value) {},
              ),
              Expanded(
                child: Text(
                  'Track inventory for this product',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              Expanded(
                child: Text(
                  'Continue selling when out of stock',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}