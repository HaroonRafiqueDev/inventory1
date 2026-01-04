import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/stock_adjustment_model.dart';
import 'package:hive/hive.dart';

class StockAdjustmentRepository {
  Box<StockAdjustmentModel> get _adjustmentBox =>
      HiveService.getBox<StockAdjustmentModel>('stock_adjustments');
  Box<ProductModel> get _productBox =>
      HiveService.getBox<ProductModel>('products');

  Future<List<StockAdjustmentModel>> getAllAdjustments() async {
    final adjustments = _adjustmentBox.values.toList();
    adjustments.sort((a, b) => b.adjustmentDate.compareTo(a.adjustmentDate));
    return adjustments;
  }

  Future<void> createAdjustment(StockAdjustmentModel adjustment) async {
    // 1. Save Adjustment
    final id = await _adjustmentBox.add(adjustment);
    adjustment.id = id;
    await adjustment.save();

    // 2. Update Product Stock
    final product = _productBox.get(adjustment.productId);
    if (product != null) {
      product.quantity += adjustment.quantityAdjustment;
      if (product.quantity < 0) {
        product.quantity = 0; // Prevent negative stock
      }
      product.updatedAt = DateTime.now();
      await _productBox.put(product.id, product);
    }
  }
}
