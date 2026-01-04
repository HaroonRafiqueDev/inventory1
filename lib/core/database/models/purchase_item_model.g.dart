// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseItemModelAdapter extends TypeAdapter<PurchaseItemModel> {
  @override
  final int typeId = 6;

  @override
  PurchaseItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseItemModel()
      ..id = fields[0] as int?
      ..purchaseId = fields[1] as int
      ..productId = fields[2] as int
      ..quantity = fields[3] as int
      ..purchasePrice = fields[4] as double
      ..totalPrice = fields[5] as double
      ..createdAt = fields[6] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PurchaseItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.totalPrice)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
