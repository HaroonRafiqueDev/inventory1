import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/purchase_item_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:hive/hive.dart';

class PurchaseRepository {
  Box<PurchaseModel> get _purchaseBox =>
      HiveService.getBox<PurchaseModel>('purchases');
  Box<PurchaseItemModel> get _itemBox =>
      HiveService.getBox<PurchaseItemModel>('purchase_items');
  Box<ProductModel> get _productBox =>
      HiveService.getBox<ProductModel>('products');

  Future<List<PurchaseModel>> getAllPurchases() async {
    final purchases = _purchaseBox.values.toList();
    purchases.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return purchases;
  }

  Future<List<PurchaseItemModel>> getPurchaseItems(int purchaseId) async {
    return _itemBox.values
        .where((item) => item.purchaseId == purchaseId)
        .toList();
  }

  Future<void> createPurchase(
      PurchaseModel purchase, List<PurchaseItemModel> items) async {
    // 1. Save Purchase
    final purchaseId = await _purchaseBox.add(purchase);
    purchase.id = purchaseId;
    await purchase.save();

    // 2. Save Items and Update Stock
    for (var item in items) {
      item.purchaseId = purchaseId;
      final itemId = await _itemBox.add(item);
      item.id = itemId;
      await item.save();

      // Update Product Stock
      final product = _productBox.get(item.productId);
      if (product != null) {
        product.quantity += item.quantity;
        product.updatedAt = DateTime.now();
        await _productBox.put(product.id, product);
      }
    }
  }

  Future<void> deletePurchase(int purchaseId) async {
    final items =
        _itemBox.values.where((item) => item.purchaseId == purchaseId).toList();

    // Reverse stock updates
    for (var item in items) {
      final product = _productBox.get(item.productId);
      if (product != null) {
        product.quantity -= item.quantity;
        product.updatedAt = DateTime.now();
        await _productBox.put(product.id, product);
      }
      await _itemBox.delete(item.id);
    }

    await _purchaseBox.delete(purchaseId);
  }
}
