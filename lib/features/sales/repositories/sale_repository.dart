import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/sale_item_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:hive/hive.dart';

class SaleRepository {
  Box<SaleModel> get _saleBox => HiveService.getBox<SaleModel>('sales');
  Box<SaleItemModel> get _itemBox =>
      HiveService.getBox<SaleItemModel>('sale_items');
  Box<ProductModel> get _productBox =>
      HiveService.getBox<ProductModel>('products');

  Future<List<SaleModel>> getAllSales() async {
    final sales = _saleBox.values.toList();
    sales.sort((a, b) => b.saleDate.compareTo(a.saleDate));
    return sales;
  }

  Future<List<SaleItemModel>> getSaleItems(int saleId) async {
    return _itemBox.values.where((item) => item.saleId == saleId).toList();
  }

  Future<void> createSale(SaleModel sale, List<SaleItemModel> items) async {
    // 1. Save Sale
    final saleId = await _saleBox.add(sale);
    sale.id = saleId;
    await sale.save();

    // 2. Save Items and Update Stock
    for (var item in items) {
      item.saleId = saleId;
      final itemId = await _itemBox.add(item);
      item.id = itemId;
      await item.save();

      // Update Product Stock
      final product = _productBox.get(item.productId);
      if (product != null) {
        if (product.quantity < item.quantity) {
          throw Exception('Insufficient stock for ${product.name}');
        }
        product.quantity -= item.quantity;
        product.updatedAt = DateTime.now();
        await _productBox.put(product.id, product);
      }
    }
  }

  Future<void> deleteSale(int saleId) async {
    final items =
        _itemBox.values.where((item) => item.saleId == saleId).toList();

    // Reverse stock updates
    for (var item in items) {
      final product = _productBox.get(item.productId);
      if (product != null) {
        product.quantity += item.quantity;
        product.updatedAt = DateTime.now();
        await _productBox.put(product.id, product);
      }
      await _itemBox.delete(item.id);
    }

    await _saleBox.delete(saleId);
  }
}
