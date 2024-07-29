// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalOrder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 100; // Unique adapter ID

  @override
  Priority read(BinaryReader reader) {
    return Priority.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    writer.writeByte(obj.index);
  }
}

class LocalOrderAdapter extends TypeAdapter<LocalOrder> {
  @override
  final int typeId = 2;

  @override
  LocalOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalOrder(
      id: fields[0] as String?,
      site: fields[1] as String,
      clientName: fields[2] as String,
      dateCommande: fields[3] as String,
      dateLivraison: fields[4] as String,
      articles: (fields[5] as List).cast<LocalArticle>(),
      priority: fields[6] as Priority,
      etatCommande: fields[7] as String,
      observation: fields[8] as String,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocalOrder obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.site)
      ..writeByte(2)
      ..write(obj.clientName)
      ..writeByte(3)
      ..write(obj.dateCommande)
      ..writeByte(4)
      ..write(obj.dateLivraison)
      ..writeByte(5)
      ..write(obj.articles)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.etatCommande)
      ..writeByte(8)
      ..write(obj.observation)
      ..writeByte(9)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
