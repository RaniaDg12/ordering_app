// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalArticle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalArticleAdapter extends TypeAdapter<LocalArticle> {
  @override
  final int typeId = 1;

  @override
  LocalArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalArticle(
      id: fields[0] as String,
      name: fields[1] as String,
      quantity: fields[2] as int,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalArticle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
