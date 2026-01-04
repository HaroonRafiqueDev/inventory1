import 'package:hive/hive.dart';

part 'sale_model.g.dart';

@HiveType(typeId: 7)
class SaleModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String saleNumber = '';

  @HiveField(2)
  String? customerName;

  @HiveField(3)
  double totalAmount = 0.0;

  @HiveField(4)
  double totalProfit = 0.0;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime saleDate = DateTime.now();

  @HiveField(7)
  DateTime createdAt = DateTime.now();

  @HiveField(8)
  DateTime updatedAt = DateTime.now();
}
