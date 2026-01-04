import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name = '';

  @HiveField(2)
  String sku = '';

  @HiveField(3)
  int categoryId = 0;

  @HiveField(4)
  double purchasePrice = 0.0;

  @HiveField(5)
  double sellingPrice = 0.0;

  @HiveField(6)
  int quantity = 0;

  @HiveField(7)
  int minStockThreshold = 0;

  @HiveField(8)
  int? supplierId;

  @HiveField(9)
  String? notes;

  @HiveField(10)
  bool isActive = true;

  @HiveField(11)
  DateTime createdAt = DateTime.now();

  @HiveField(12)
  DateTime updatedAt = DateTime.now();
}
