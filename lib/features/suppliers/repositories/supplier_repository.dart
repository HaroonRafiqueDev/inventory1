import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:hive/hive.dart';

class SupplierRepository {
  Box<SupplierModel> get _box => HiveService.getBox<SupplierModel>('suppliers');

  Future<List<SupplierModel>> getAllSuppliers() async {
    return _box.values.toList();
  }

  Future<SupplierModel?> getSupplierById(int id) async {
    return _box.get(id);
  }

  Future<void> saveSupplier(SupplierModel supplier) async {
    supplier.updatedAt = DateTime.now();
    if (supplier.id == null) {
      final id = await _box.add(supplier);
      supplier.id = id;
      await supplier.save();
    } else {
      await _box.put(supplier.id, supplier);
    }
  }

  Future<void> deleteSupplier(int id) async {
    await _box.delete(id);
  }

  Future<List<SupplierModel>> searchSuppliers(String query) async {
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((s) =>
            s.name.toLowerCase().contains(lowerQuery) ||
            (s.email?.toLowerCase().contains(lowerQuery) ?? false) ||
            (s.phone?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }
}
