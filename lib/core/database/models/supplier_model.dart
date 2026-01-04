import 'package:hive/hive.dart';

part 'supplier_model.g.dart';

@HiveType(typeId: 4)
class SupplierModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name = '';

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? address;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  bool isActive = true;

  @HiveField(7)
  DateTime createdAt = DateTime.now();

  @HiveField(8)
  DateTime updatedAt = DateTime.now();
}
