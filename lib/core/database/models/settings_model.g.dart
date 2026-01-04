// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 10;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel()
      ..id = fields[0] as int?
      ..businessName = fields[1] as String
      ..businessLogoPath = fields[2] as String?
      ..invoiceFooterText = fields[3] as String?
      ..businessAddress = fields[4] as String?
      ..businessPhone = fields[5] as String?
      ..currency = fields[6] as String
      ..dateFormat = fields[7] as String
      ..taxPercentage = fields[8] as double
      ..isDarkMode = fields[9] as bool
      ..updatedAt = fields[10] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessName)
      ..writeByte(2)
      ..write(obj.businessLogoPath)
      ..writeByte(3)
      ..write(obj.invoiceFooterText)
      ..writeByte(4)
      ..write(obj.businessAddress)
      ..writeByte(5)
      ..write(obj.businessPhone)
      ..writeByte(6)
      ..write(obj.currency)
      ..writeByte(7)
      ..write(obj.dateFormat)
      ..writeByte(8)
      ..write(obj.taxPercentage)
      ..writeByte(9)
      ..write(obj.isDarkMode)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
