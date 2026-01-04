import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:inventory_system/features/sales/providers/sale_bloc.dart';
import 'package:inventory_system/features/sales/screens/sale_form_screen.dart';
import 'package:intl/intl.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS & Sales History'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SaleFormScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Open POS'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<SaleBloc, SaleState>(
        listener: (context, state) {
          if (state is SaleOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SaleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SaleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SalesLoaded) {
            if (state.sales.isEmpty) {
              return const Center(child: Text('No sales found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.sales.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final sale = state.sales[index];
                return Card(
                  child: ListTile(
                    title: Text(sale.saleNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${sale.customerName} | ${DateFormat('dd MMM yyyy HH:mm').format(sale.saleDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${sale.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                                'Profit: \$${sale.totalProfit.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.green)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _confirmDelete(context, sale),
                        ),
                      ],
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

  void _confirmDelete(BuildContext context, SaleModel sale) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text(
            'Are you sure you want to delete this sale? This will reverse the stock updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              if (sale.id != null) {
                context.read<SaleBloc>().add(DeleteSale(sale.id!));
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
