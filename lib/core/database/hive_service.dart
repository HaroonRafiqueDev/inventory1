import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_system/core/database/models/user_model.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/category_model.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/core/database/models/purchase_item_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:inventory_system/core/database/models/sale_item_model.dart';
import 'package:inventory_system/core/database/models/stock_adjustment_model.dart';
import 'package:inventory_system/core/database/models/settings_model.dart';
import 'package:inventory_system/core/database/models/license_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserRoleAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(SupplierModelAdapter());
    Hive.registerAdapter(PurchaseModelAdapter());
    Hive.registerAdapter(PurchaseItemModelAdapter());
    Hive.registerAdapter(SaleModelAdapter());
    Hive.registerAdapter(SaleItemModelAdapter());
    Hive.registerAdapter(StockAdjustmentModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());
    Hive.registerAdapter(LicenseModelAdapter());

    // Open Boxes
    await Hive.openBox<UserModel>('users');
    await Hive.openBox<ProductModel>('products');
    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<SupplierModel>('suppliers');
    await Hive.openBox<PurchaseModel>('purchases');
    await Hive.openBox<PurchaseItemModel>('purchase_items');
    await Hive.openBox<SaleModel>('sales');
    await Hive.openBox<SaleItemModel>('sale_items');
    await Hive.openBox<StockAdjustmentModel>('stock_adjustments');
    await Hive.openBox<SettingsModel>('settings');
    await Hive.openBox<LicenseModel>('license');
  }

  static Box<T> getBox<T>(String name) {
    return Hive.box<T>(name);
  }
}
