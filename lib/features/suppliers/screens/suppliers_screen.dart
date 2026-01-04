import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:inventory_system/features/suppliers/providers/supplier_bloc.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          SizedBox(
            width: 300,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search suppliers...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) {
                context.read<SupplierBloc>().add(SearchSuppliers(value));
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _showSupplierDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Supplier'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is SupplierOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SupplierError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SupplierLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SuppliersLoaded) {
            if (state.suppliers.isEmpty) {
              return const Center(child: Text('No suppliers found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.suppliers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final supplier = state.suppliers[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(supplier.name[0].toUpperCase()),
                    ),
                    title: Text(supplier.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${supplier.phone ?? "No phone"} | ${supplier.email ?? "No email"}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () =>
                              _showSupplierDialog(context, supplier: supplier),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _confirmDelete(context, supplier),
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

  void _showSupplierDialog(BuildContext context, {SupplierModel? supplier}) {
    final nameController = TextEditingController(text: supplier?.name);
    final phoneController = TextEditingController(text: supplier?.phone);
    final emailController = TextEditingController(text: supplier?.email);
    final addressController = TextEditingController(text: supplier?.address);
    final notesController = TextEditingController(text: supplier?.notes);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Supplier Name *'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
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
              if (formKey.currentState!.validate()) {
                final newSupplier = supplier ?? SupplierModel();
                newSupplier.name = nameController.text;
                newSupplier.phone = phoneController.text;
                newSupplier.email = emailController.text;
                newSupplier.address = addressController.text;
                newSupplier.notes = notesController.text;
                newSupplier.isActive = true;
                newSupplier.createdAt = supplier?.createdAt ?? DateTime.now();

                if (supplier == null) {
                  context.read<SupplierBloc>().add(AddSupplier(newSupplier));
                } else {
                  context.read<SupplierBloc>().add(UpdateSupplier(newSupplier));
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, SupplierModel supplier) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Are you sure you want to delete "${supplier.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              if (supplier.id != null) {
                context.read<SupplierBloc>().add(DeleteSupplier(supplier.id!));
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
