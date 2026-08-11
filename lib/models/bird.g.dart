// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bird.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BirdAdapter extends TypeAdapter<Bird> {
  @override
  final int typeId = 0;

  @override
  Bird read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bird(
      name: fields[0] as String,
      species: fields[1] as String,
      hatchDate: fields[5] as DateTime?,
      gender: fields[3] as String,
      imagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Bird obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.species)
      ..writeByte(5)
      ..write(obj.hatchDate)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
