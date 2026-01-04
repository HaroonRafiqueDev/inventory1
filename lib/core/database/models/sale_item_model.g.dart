// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleItemModelAdapter extends TypeAdapter<SaleItemModel> {
  @override
  final int typeId = 8;

  @override
  SaleItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleItemModel()
      ..id = fields[0] as int?
      ..saleId = fields[1] as int
      ..productId = fields[2] as int
      ..quantity = fields[3] as int
      ..sellingPrice = fields[4] as double
      ..purchasePrice = fields[5] as double
      ..totalPrice = fields[6] as double
      ..createdAt = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SaleItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.saleId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.purchasePrice)
      ..writeByte(6)
      ..write(obj.totalPrice)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
