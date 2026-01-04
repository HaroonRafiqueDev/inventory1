// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_adjustment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdjustmentModelAdapter extends TypeAdapter<StockAdjustmentModel> {
  @override
  final int typeId = 9;

  @override
  StockAdjustmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockAdjustmentModel()
      ..id = fields[0] as int?
      ..productId = fields[1] as int
      ..quantityAdjustment = fields[2] as int
      ..reason = fields[3] as String
      ..adjustmentDate = fields[4] as DateTime
      ..userId = fields[5] as int
      ..createdAt = fields[6] as DateTime;
  }

  @override
  void write(BinaryWriter writer, StockAdjustmentModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.quantityAdjustment)
      ..writeByte(3)
      ..write(obj.reason)
      ..writeByte(4)
      ..write(obj.adjustmentDate)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAdjustmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
