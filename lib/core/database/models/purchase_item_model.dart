import 'package:hive/hive.dart';

part 'purchase_item_model.g.dart';

@HiveType(typeId: 6)
class PurchaseItemModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int purchaseId = 0;

  @HiveField(2)
  int productId = 0;

  @HiveField(3)
  int quantity = 0;

  @HiveField(4)
  double purchasePrice = 0.0;

  @HiveField(5)
  double totalPrice = 0.0;

  @HiveField(6)
  DateTime createdAt = DateTime.now();
}
