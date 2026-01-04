// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseModelAdapter extends TypeAdapter<PurchaseModel> {
  @override
  final int typeId = 5;

  @override
  PurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseModel()
      ..id = fields[0] as int?
      ..purchaseNumber = fields[1] as String
      ..supplierId = fields[2] as int
      ..totalAmount = fields[3] as double
      ..notes = fields[4] as String?
      ..purchaseDate = fields[5] as DateTime
      ..createdAt = fields[6] as DateTime
      ..updatedAt = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PurchaseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseNumber)
      ..writeByte(2)
      ..write(obj.supplierId)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
