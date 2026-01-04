import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/features/categories/providers/category_bloc.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _minStockController;
  late TextEditingController _notesController;
  int? _selectedCategoryId;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _skuController = TextEditingController(text: widget.product?.sku);
    _purchasePriceController = TextEditingController(
        text: widget.product?.purchasePrice.toString() ?? '0.0');
    _sellingPriceController = TextEditingController(
        text: widget.product?.sellingPrice.toString() ?? '0.0');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '0');
    _minStockController = TextEditingController(
        text: widget.product?.minStockThreshold.toString() ?? '10');
    _notesController = TextEditingController(text: widget.product?.notes);
    _selectedCategoryId = widget.product?.categoryId;
    _isActive = widget.product?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name *'),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _skuController,
                              decoration: const InputDecoration(
                                  labelText: 'SKU / Item Code *'),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<CategoryBloc, CategoryState>(
                              builder: (context, state) {
                                if (state is CategoriesLoaded) {
                                  return DropdownButtonFormField<int>(
                                    initialValue: _selectedCategoryId,
                                    decoration: const InputDecoration(
                                        labelText: 'Category *'),
                                    items: state.categories.map((c) {
                                      return DropdownMenuItem(
                                          value: c.id, child: Text(c.name));
                                    }).toList(),
                                    onChanged: (value) => setState(
                                        () => _selectedCategoryId = value),
                                    validator: (value) =>
                                        value == null ? 'Required' : null,
                                  );
                                }
                                return const Text('Loading categories...');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Active Status'),
                              value: _isActive,
                              onChanged: (value) =>
                                  setState(() => _isActive = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _purchasePriceController,
                              decoration: const InputDecoration(
                                  labelText: 'Purchase Price',
                                  prefixText: '\$'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _sellingPriceController,
                              decoration: const InputDecoration(
                                  labelText: 'Selling Price *',
                                  prefixText: '\$'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                  labelText: 'Initial Stock Quantity *'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _minStockController,
                              decoration: const InputDecoration(
                                  labelText: 'Min Stock Threshold'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(labelText: 'Notes'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _saveProduct,
                            child: const Text('Save Product'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = widget.product ?? ProductModel();
      product.name = _nameController.text;
      product.sku = _skuController.text;
      product.categoryId = _selectedCategoryId!;
      product.purchasePrice =
          double.tryParse(_purchasePriceController.text) ?? 0.0;
      product.sellingPrice =
          double.tryParse(_sellingPriceController.text) ?? 0.0;
      product.quantity = int.tryParse(_quantityController.text) ?? 0;
      product.minStockThreshold = int.tryParse(_minStockController.text) ?? 10;
      product.notes = _notesController.text;
      product.isActive = _isActive;
      product.createdAt = widget.product?.createdAt ?? DateTime.now();

      if (widget.product == null) {
        context.read<ProductBloc>().add(AddProduct(product));
      } else {
        context.read<ProductBloc>().add(UpdateProduct(product));
      }
      Navigator.pop(context);
    }
  }
}
