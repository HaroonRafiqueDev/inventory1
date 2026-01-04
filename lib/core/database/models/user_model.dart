import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String username = '';

  @HiveField(2)
  String passwordHash = '';

  @HiveField(3)
  UserRole role = UserRole.staff;

  @HiveField(4)
  List<String> permissions = [];

  @HiveField(5)
  bool isActive = true;

  @HiveField(6)
  DateTime createdAt = DateTime.now();

  @HiveField(7)
  DateTime updatedAt = DateTime.now();
}

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  staff
}
