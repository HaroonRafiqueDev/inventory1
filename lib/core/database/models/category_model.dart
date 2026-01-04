import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 3)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name = '';

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool isActive = true;

  @HiveField(4)
  DateTime createdAt = DateTime.now();

  @HiveField(5)
  DateTime updatedAt = DateTime.now();
}
