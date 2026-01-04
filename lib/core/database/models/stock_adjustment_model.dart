import 'package:hive/hive.dart';

part 'stock_adjustment_model.g.dart';

@HiveType(typeId: 9)
class StockAdjustmentModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int productId = 0;

  @HiveField(2)
  int quantityAdjustment = 0;

  @HiveField(3)
  String reason = '';

  @HiveField(4)
  DateTime adjustmentDate = DateTime.now();

  @HiveField(5)
  int userId = 0;

  @HiveField(6)
  DateTime createdAt = DateTime.now();
}
