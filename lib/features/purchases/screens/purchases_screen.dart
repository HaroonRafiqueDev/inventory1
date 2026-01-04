import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:inventory_system/features/purchases/providers/purchase_bloc.dart';
import 'package:inventory_system/features/purchases/screens/purchase_form_screen.dart';
import 'package:inventory_system/features/suppliers/providers/supplier_bloc.dart';
import 'package:intl/intl.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PurchaseFormScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('New Purchase'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PurchasesLoaded) {
            if (state.purchases.isEmpty) {
              return const Center(child: Text('No purchases found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.purchases.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final purchase = state.purchases[index];
                return Card(
                  child: ListTile(
                    title: Text(purchase.purchaseNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: BlocBuilder<SupplierBloc, SupplierState>(
                      builder: (context, supplierState) {
                        String supplierName = 'Loading...';
                        if (supplierState is SuppliersLoaded) {
                          supplierName = supplierState.suppliers
                              .firstWhere((s) => s.id == purchase.supplierId,
                                  orElse: () =>
                                      SupplierModel()..name = 'Unknown')
                              .name;
                        }
                        return Text(
                            '$supplierName | ${DateFormat('dd MMM yyyy HH:mm').format(purchase.purchaseDate)}');
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${purchase.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _confirmDelete(context, purchase),
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

  void _confirmDelete(BuildContext context, PurchaseModel purchase) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Purchase'),
        content: const Text(
            'Are you sure you want to delete this purchase? This will reverse the stock updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              if (purchase.id != null) {
                context.read<PurchaseBloc>().add(DeletePurchase(purchase.id!));
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
