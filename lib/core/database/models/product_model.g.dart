// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel()
      ..id = fields[0] as int?
      ..name = fields[1] as String
      ..sku = fields[2] as String
      ..categoryId = fields[3] as int
      ..purchasePrice = fields[4] as double
      ..sellingPrice = fields[5] as double
      ..quantity = fields[6] as int
      ..minStockThreshold = fields[7] as int
      ..supplierId = fields[8] as int?
      ..notes = fields[9] as String?
      ..isActive = fields[10] as bool
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.sellingPrice)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.minStockThreshold)
      ..writeByte(8)
      ..write(obj.supplierId)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
