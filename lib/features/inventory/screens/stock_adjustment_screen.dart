import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/stock_adjustment_model.dart';
import 'package:inventory_system/features/inventory/providers/stock_adjustment_bloc.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:intl/intl.dart';

class StockAdjustmentScreen extends StatelessWidget {
  const StockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Adjustments'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showAdjustmentDialog(context),
            icon: const Icon(Icons.tune),
            label: const Text('New Adjustment'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<StockAdjustmentBloc, StockAdjustmentState>(
        listener: (context, state) {
          if (state is StockAdjustmentOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is StockAdjustmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is StockAdjustmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StockAdjustmentsLoaded) {
            if (state.adjustments.isEmpty) {
              return const Center(child: Text('No adjustments found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.adjustments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final adj = state.adjustments[index];
                final isPositive = adj.quantityAdjustment > 0;
                return Card(
                  child: ListTile(
                    title: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        String productName = 'Loading...';
                        if (productState is ProductsLoaded) {
                          productName = productState.products
                              .firstWhere((p) => p.id == adj.productId,
                                  orElse: () =>
                                      ProductModel()..name = 'Unknown')
                              .name;
                        }
                        return Text(productName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold));
                      },
                    ),
                    subtitle: Text(
                        '${adj.reason} | ${DateFormat('dd MMM yyyy HH:mm').format(adj.adjustmentDate)}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${isPositive ? "+" : ""}${adj.quantityAdjustment}',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context) {
    ProductModel? selectedProduct;
    final qtyController = TextEditingController();
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isAddition = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Stock Adjustment'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductsLoaded) {
                        return DropdownButtonFormField<ProductModel>(
                          initialValue: selectedProduct,
                          decoration: const InputDecoration(
                              labelText: 'Select Product *'),
                          items: state.products.map((p) {
                            return DropdownMenuItem(
                                value: p,
                                child:
                                    Text('${p.name} (Stock: ${p.quantity})'));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedProduct = value),
                          validator: (value) =>
                              value == null ? 'Required' : null,
                        );
                      }
                      return const Text('Loading products...');
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Add'),
                          value: true,
                          groupValue: isAddition,
                          onChanged: (value) =>
                              setState(() => isAddition = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Remove'),
                          value: false,
                          groupValue: isAddition,
                          onChanged: (value) =>
                              setState(() => isAddition = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: qtyController,
                    decoration: const InputDecoration(labelText: 'Quantity *'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                        labelText: 'Reason (e.g., Damage, Correction) *'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    selectedProduct != null) {
                  final qty = int.tryParse(qtyController.text) ?? 0;
                  final change = isAddition ? qty : -qty;

                  final adj = StockAdjustmentModel()
                    ..productId = selectedProduct!.id!
                    ..quantityAdjustment = change
                    ..reason = reasonController.text
                    ..adjustmentDate = DateTime.now()
                    ..userId = 1; // Default admin for now

                  context
                      .read<StockAdjustmentBloc>()
                      .add(CreateAdjustment(adj));
                  Navigator.pop(context);
                }
              },
              child: const Text('Adjust Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
