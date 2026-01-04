import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/purchase_item_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:inventory_system/features/purchases/providers/purchase_bloc.dart';
import 'package:inventory_system/features/suppliers/providers/supplier_bloc.dart';

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({super.key});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _purchaseNumberController = TextEditingController(
      text: 'PUR-${DateTime.now().millisecondsSinceEpoch}');
  final _notesController = TextEditingController();
  int? _selectedSupplierId;
  final List<PurchaseItemModel> _items = [];

  // For adding new item
  ProductModel? _selectedProduct;
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController(text: '0.0');

  double get _totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  void dispose() {
    _purchaseNumberController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Purchase (Stock In)'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Form and Items List
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _purchaseNumberController,
                                    decoration: const InputDecoration(
                                        labelText: 'Purchase Number'),
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child:
                                      BlocBuilder<SupplierBloc, SupplierState>(
                                    builder: (context, state) {
                                      if (state is SuppliersLoaded) {
                                        return DropdownButtonFormField<int>(
                                          initialValue: _selectedSupplierId,
                                          decoration: const InputDecoration(
                                              labelText: 'Supplier *'),
                                          items: state.suppliers.map((s) {
                                            return DropdownMenuItem(
                                                value: s.id,
                                                child: Text(s.name));
                                          }).toList(),
                                          onChanged: (value) => setState(() =>
                                              _selectedSupplierId = value),
                                          validator: (value) =>
                                              value == null ? 'Required' : null,
                                        );
                                      }
                                      return const Text('Loading suppliers...');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Purchase Items',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: _items.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: Text('No items added yet.')),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _items.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  String productName = 'Unknown Product';
                                  if (state is ProductsLoaded) {
                                    productName = state.products
                                        .firstWhere(
                                            (p) => p.id == item.productId)
                                        .name;
                                  }
                                  return ListTile(
                                    title: Text(productName),
                                    subtitle: Text(
                                        'Qty: ${item.quantity} x \$${item.purchasePrice.toStringAsFixed(2)}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            '\$${item.totalPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red),
                                          onPressed: () => setState(
                                              () => _items.removeAt(index)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Right Side: Add Item and Summary
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Product',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              if (state is ProductsLoaded) {
                                return DropdownButtonFormField<ProductModel>(
                                  initialValue: _selectedProduct,
                                  decoration: const InputDecoration(
                                      labelText: 'Select Product'),
                                  items: state.products.map((p) {
                                    return DropdownMenuItem(
                                        value: p, child: Text(p.name));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProduct = value;
                                      _priceController.text =
                                          value?.purchasePrice.toString() ??
                                              '0.0';
                                    });
                                  },
                                );
                              }
                              return const Text('Loading products...');
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _quantityController,
                                  decoration: const InputDecoration(
                                      labelText: 'Quantity'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                      labelText: 'Price', prefixText: '\$'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _addItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Add to List'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('\$${_totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                                labelText: 'Purchase Notes'),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: _items.isEmpty ? null : _savePurchase,
                              child: const Text('Complete Purchase',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
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

  void _addItem() {
    if (_selectedProduct == null) return;
    final qty = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (qty <= 0) return;

    setState(() {
      _items.add(PurchaseItemModel()
        ..productId = _selectedProduct!.id!
        ..quantity = qty
        ..purchasePrice = price
        ..totalPrice = qty * price
        ..createdAt = DateTime.now());

      _selectedProduct = null;
      _quantityController.text = '1';
      _priceController.text = '0.0';
    });
  }

  void _savePurchase() {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final purchase = PurchaseModel()
        ..purchaseNumber = _purchaseNumberController.text
        ..supplierId = _selectedSupplierId!
        ..totalAmount = _totalAmount
        ..notes = _notesController.text
        ..purchaseDate = DateTime.now()
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      context.read<PurchaseBloc>().add(CreatePurchase(purchase, _items));
      Navigator.pop(context);
    }
  }
}
