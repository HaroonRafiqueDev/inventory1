import 'package:hive/hive.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 5)
class PurchaseModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String purchaseNumber = '';

  @HiveField(2)
  int supplierId = 0;

  @HiveField(3)
  double totalAmount = 0.0;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  DateTime purchaseDate = DateTime.now();

  @HiveField(6)
  DateTime createdAt = DateTime.now();

  @HiveField(7)
  DateTime updatedAt = DateTime.now();
}
