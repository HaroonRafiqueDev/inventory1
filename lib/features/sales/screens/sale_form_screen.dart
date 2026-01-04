import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/sale_item_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:inventory_system/features/categories/providers/category_bloc.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:inventory_system/features/sales/providers/sale_bloc.dart';
import 'package:inventory_system/core/config/app_config.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _saleNumberController = TextEditingController(
      text: 'SALE-${DateTime.now().millisecondsSinceEpoch}');
  final _customerNameController =
      TextEditingController(text: 'Walk-in Customer');
  final _notesController = TextEditingController();
  final List<SaleItemModel> _items = [];

  // POS State
  String _searchQuery = '';
  int? _selectedCategoryId;
  final _searchController = TextEditingController();

  // For adding new item
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController(text: '0.0');

  double get _totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get _totalProfit => _items.fold(
      0,
      (sum, item) =>
          sum + (item.sellingPrice - item.purchasePrice) * item.quantity);

  @override
  void dispose() {
    _saleNumberController.dispose();
    _customerNameController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS - Top Store'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                _saleNumberController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Product Selection
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Search and Filter Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products by name or SKU...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Filters
                SizedBox(
                  height: 50,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: const Text('All'),
                                  selected: _selectedCategoryId == null,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategoryId = null;
                                    });
                                  },
                                ),
                              );
                            }
                            final category = state.categories[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category.name),
                                selected: _selectedCategoryId == category.id,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategoryId =
                                        selected ? category.id : null;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),

                const Divider(),

                // Product Grid
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductsLoaded) {
                        final filteredProducts = state.products.where((p) {
                          final matchesSearch =
                              p.name.toLowerCase().contains(_searchQuery) ||
                                  p.sku.toLowerCase().contains(_searchQuery);
                          final matchesCategory = _selectedCategoryId == null ||
                              p.categoryId == _selectedCategoryId;
                          return p.isActive && matchesSearch && matchesCategory;
                        }).toList();

                        if (filteredProducts.isEmpty) {
                          return const Center(child: Text('No products found'));
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _ProductCard(
                              product: product,
                              onTap: () => _addItemFromGrid(product),
                            );
                          },
                        );
                      }
                      return const Center(
                          child: Text('Error loading products'));
                    },
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(width: 1),

          // Right Side: Cart and Checkout
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  // Customer Selection
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const Divider(),

                  // Cart Items
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Cart is empty',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _items.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  String productName = 'Unknown';
                                  if (state is ProductsLoaded) {
                                    productName = state.products
                                        .firstWhere(
                                            (p) => p.id == item.productId)
                                        .name;
                                  }
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(productName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        '${AppConfig.defaultCurrency}${item.sellingPrice.toStringAsFixed(2)}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: () =>
                                              _updateItemQuantity(index, -1),
                                        ),
                                        Text('${item.quantity}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: () =>
                                              _updateItemQuantity(index, 1),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${AppConfig.defaultCurrency}${item.totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),

                  // Summary and Checkout
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.05),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                                '${AppConfig.defaultCurrency}${_totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _items.isEmpty ? null : _saveSale,
                            child: const Text('CHECKOUT',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addItemFromGrid(ProductModel product) {
    if (product.quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Out of stock!'), backgroundColor: Colors.red),
      );
      return;
    }

    final existingIndex =
        _items.indexWhere((item) => item.productId == product.id);

    setState(() {
      if (existingIndex != -1) {
        if (_items[existingIndex].quantity < product.quantity) {
          _items[existingIndex].quantity++;
          _items[existingIndex].totalPrice = _items[existingIndex].quantity *
              _items[existingIndex].sellingPrice;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Insufficient stock!'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        _items.add(SaleItemModel()
          ..productId = product.id!
          ..quantity = 1
          ..sellingPrice = product.sellingPrice
          ..purchasePrice = product.purchasePrice
          ..totalPrice = product.sellingPrice
          ..createdAt = DateTime.now());
      }
    });
  }

  void _updateItemQuantity(int index, int delta) {
    final item = _items[index];
    final productBloc = context.read<ProductBloc>();
    final state = productBloc.state;

    if (state is ProductsLoaded) {
      final product = state.products.firstWhere((p) => p.id == item.productId);
      final newQty = item.quantity + delta;

      if (newQty <= 0) {
        setState(() {
          _items.removeAt(index);
        });
      } else if (newQty <= product.quantity) {
        setState(() {
          item.quantity = newQty;
          item.totalPrice = newQty * item.sellingPrice;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Insufficient stock!'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _saveSale() {
    if (_items.isNotEmpty) {
      final sale = SaleModel()
        ..saleNumber = _saleNumberController.text
        ..customerName = _customerNameController.text.isEmpty
            ? 'Walk-in Customer'
            : _customerNameController.text
        ..totalAmount = _totalAmount
        ..totalProfit = _totalProfit
        ..notes = _notesController.text
        ..saleDate = DateTime.now()
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      context.read<SaleBloc>().add(CreateSale(sale, _items));
      Navigator.pop(context);
    }
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.inventory_2,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConfig.defaultCurrency}${product.sellingPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.quantity < 10 ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
