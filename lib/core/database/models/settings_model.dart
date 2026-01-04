import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 10)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String businessName = '';

  @HiveField(2)
  String? businessLogoPath;

  @HiveField(3)
  String? invoiceFooterText;

  @HiveField(4)
  String? businessAddress;

  @HiveField(5)
  String? businessPhone;

  @HiveField(6)
  String currency = 'USD';

  @HiveField(7)
  String dateFormat = 'yyyy-MM-dd';

  @HiveField(8)
  double taxPercentage = 0.0;

  @HiveField(9)
  bool isDarkMode = false;

  @HiveField(10)
  DateTime updatedAt = DateTime.now();
}
