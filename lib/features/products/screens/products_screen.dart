import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:inventory_system/features/products/screens/product_form_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          SizedBox(
            width: 300,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(value));
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProductFormScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('SKU')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: state.products.map((product) {
                    final isLowStock =
                        product.quantity <= product.minStockThreshold;
                    return DataRow(
                      cells: [
                        DataCell(Text(product.sku)),
                        DataCell(Text(product.name)),
                        DataCell(
                          Row(
                            children: [
                              Text(
                                product.quantity.toString(),
                                style: TextStyle(
                                  color: isLowStock ? Colors.red : null,
                                  fontWeight:
                                      isLowStock ? FontWeight.bold : null,
                                ),
                              ),
                              if (isLowStock)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.warning_amber_rounded,
                                      color: Colors.red, size: 16),
                                ),
                            ],
                          ),
                        ),
                        DataCell(Text(
                            '\$${product.sellingPrice.toStringAsFixed(2)}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: product.isActive
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: product.isActive
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductFormScreen(product: product),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: Colors.red),
                                onPressed: () =>
                                    _confirmDelete(context, product),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              if (product.id != null) {
                context.read<ProductBloc>().add(DeleteProduct(product.id!));
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
