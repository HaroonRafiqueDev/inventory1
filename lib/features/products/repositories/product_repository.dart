import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:hive/hive.dart';

class ProductRepository {
  Box<ProductModel> get _box => HiveService.getBox<ProductModel>('products');

  Future<List<ProductModel>> getAllProducts() async {
    return _box.values.toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    return _box.get(id);
  }

  Future<ProductModel?> getProductBySku(String sku) async {
    try {
      return _box.values.firstWhere((p) => p.sku == sku);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProduct(ProductModel product) async {
    product.updatedAt = DateTime.now();
    if (product.id == null) {
      final id = await _box.add(product);
      product.id = id;
      await product.save();
    } else {
      await _box.put(product.id, product);
    }
  }

  Future<void> deleteProduct(int id) async {
    await _box.delete(id);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.sku.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<List<ProductModel>> getLowStockProducts() async {
    return _box.values.where((p) => p.quantity <= p.minStockThreshold).toList();
  }
}
