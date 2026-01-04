import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/category_model.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:hive/hive.dart';

class CategoryRepository {
  Box<CategoryModel> get _box =>
      HiveService.getBox<CategoryModel>('categories');
  Box<ProductModel> get _productBox =>
      HiveService.getBox<ProductModel>('products');

  Future<List<CategoryModel>> getAllCategories() async {
    return _box.values.toList();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return _box.get(id);
  }

  Future<void> saveCategory(CategoryModel category) async {
    category.updatedAt = DateTime.now();
    if (category.id == null) {
      final id = await _box.add(category);
      category.id = id;
      await category.save();
    } else {
      await _box.put(category.id, category);
    }
  }

  Future<bool> deleteCategory(int id) async {
    // Check if products exist in this category
    final productCount =
        _productBox.values.where((p) => p.categoryId == id).length;

    if (productCount > 0) return false;

    await _box.delete(id);
    return true;
  }
}
