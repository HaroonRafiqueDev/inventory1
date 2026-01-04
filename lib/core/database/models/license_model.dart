import 'package:hive/hive.dart';

part 'license_model.g.dart';

@HiveType(typeId: 11)
class LicenseModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? licenseKey;

  @HiveField(2)
  DateTime? activationDate;

  @HiveField(3)
  bool isActivated = false;

  @HiveField(4)
  bool isTrial = true;

  @HiveField(5)
  DateTime? trialStartDate;

  @HiveField(6)
  String? deviceFingerprint;

  @HiveField(7)
  String? domain;

  @HiveField(8)
  DateTime updatedAt = DateTime.now();
}
