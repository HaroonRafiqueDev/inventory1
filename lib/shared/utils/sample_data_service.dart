import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/category_model.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/core/database/models/purchase_item_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:inventory_system/core/database/models/sale_item_model.dart';
import 'package:inventory_system/core/database/models/stock_adjustment_model.dart';

class SampleDataService {
  static Future<void> seedData() async {
    // 1. Seed Categories
    final categoryBox = HiveService.getBox<CategoryModel>('categories');
    final categories = [
      CategoryModel()
        ..name = 'Electronics'
        ..description = 'Gadgets and devices'
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      CategoryModel()
        ..name = 'Furniture'
        ..description = 'Office and home furniture'
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      CategoryModel()
        ..name = 'Stationery'
        ..description = 'Office supplies'
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    ];
    for (var cat in categories) {
      final id = await categoryBox.add(cat);
      cat.id = id;
      await cat.save();
    }

    // 2. Seed Suppliers
    final supplierBox = HiveService.getBox<SupplierModel>('suppliers');
    final suppliers = [
      SupplierModel()
        ..name = 'Tech Corp'
        ..phone = '123-456-7890'
        ..email = 'contact@techcorp.com'
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      SupplierModel()
        ..name = 'Global Furniture'
        ..phone = '098-765-4321'
        ..email = 'sales@globalfurniture.com'
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    ];
    for (var sup in suppliers) {
      final id = await supplierBox.add(sup);
      sup.id = id;
      await sup.save();
    }

    // 3. Seed Products
    final productBox = HiveService.getBox<ProductModel>('products');
    final products = [
      ProductModel()
        ..sku = 'LAP-001'
        ..name = 'MacBook Pro'
        ..notes = '14-inch M2 Pro'
        ..categoryId = categories[0].id!
        ..purchasePrice = 1800.0
        ..sellingPrice = 2200.0
        ..quantity = 10
        ..minStockThreshold = 2
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      ProductModel()
        ..sku = 'MOU-001'
        ..name = 'Magic Mouse'
        ..notes = 'Wireless mouse'
        ..categoryId = categories[0].id!
        ..purchasePrice = 70.0
        ..sellingPrice = 99.0
        ..quantity = 25
        ..minStockThreshold = 5
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      ProductModel()
        ..sku = 'CHA-001'
        ..name = 'Office Chair'
        ..notes = 'Ergonomic chair'
        ..categoryId = categories[1].id!
        ..purchasePrice = 150.0
        ..sellingPrice = 250.0
        ..quantity = 5
        ..minStockThreshold = 2
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    ];
    for (var prod in products) {
      final id = await productBox.add(prod);
      prod.id = id;
      await prod.save();
    }
  }

  static Future<void> clearAllData() async {
    await HiveService.getBox<ProductModel>('products').clear();
    await HiveService.getBox<CategoryModel>('categories').clear();
    await HiveService.getBox<SupplierModel>('suppliers').clear();
    await HiveService.getBox<PurchaseModel>('purchases').clear();
    await HiveService.getBox<SaleModel>('sales').clear();
    await HiveService.getBox<StockAdjustmentModel>('stock_adjustments').clear();
    await HiveService.getBox<PurchaseItemModel>('purchase_items').clear();
    await HiveService.getBox<SaleItemModel>('sale_items').clear();
  }
}
