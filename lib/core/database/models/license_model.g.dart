// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LicenseModelAdapter extends TypeAdapter<LicenseModel> {
  @override
  final int typeId = 11;

  @override
  LicenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LicenseModel()
      ..id = fields[0] as int?
      ..licenseKey = fields[1] as String?
      ..activationDate = fields[2] as DateTime?
      ..isActivated = fields[3] as bool
      ..isTrial = fields[4] as bool
      ..trialStartDate = fields[5] as DateTime?
      ..deviceFingerprint = fields[6] as String?
      ..domain = fields[7] as String?
      ..updatedAt = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, LicenseModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.licenseKey)
      ..writeByte(2)
      ..write(obj.activationDate)
      ..writeByte(3)
      ..write(obj.isActivated)
      ..writeByte(4)
      ..write(obj.isTrial)
      ..writeByte(5)
      ..write(obj.trialStartDate)
      ..writeByte(6)
      ..write(obj.deviceFingerprint)
      ..writeByte(7)
      ..write(obj.domain)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
