import 'package:hive/hive.dart';

part 'sale_item_model.g.dart';

@HiveType(typeId: 8)
class SaleItemModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int saleId = 0;

  @HiveField(2)
  int productId = 0;

  @HiveField(3)
  int quantity = 0;

  @HiveField(4)
  double sellingPrice = 0.0;

  @HiveField(5)
  double purchasePrice = 0.0;

  @HiveField(6)
  double totalPrice = 0.0;

  @HiveField(7)
  DateTime createdAt = DateTime.now();
}
