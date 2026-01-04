// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleModelAdapter extends TypeAdapter<SaleModel> {
  @override
  final int typeId = 7;

  @override
  SaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleModel()
      ..id = fields[0] as int?
      ..saleNumber = fields[1] as String
      ..customerName = fields[2] as String?
      ..totalAmount = fields[3] as double
      ..totalProfit = fields[4] as double
      ..notes = fields[5] as String?
      ..saleDate = fields[6] as DateTime
      ..createdAt = fields[7] as DateTime
      ..updatedAt = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SaleModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.saleNumber)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.totalProfit)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.saleDate)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
