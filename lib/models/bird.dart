import 'package:hive/hive.dart';

//Class for bird now utilizes hive adapter

part 'bird.g.dart';

@HiveType(typeId: 0)
class Bird {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String species;
  @HiveField(2)
  final String age;
  @HiveField(3)
  final String gender;
  @HiveField(4)
  String? imagePath;

  Bird({
    required this.name,
    required this.species,
    required this.age,
    required this.gender,
    this.imagePath,
  });
}
