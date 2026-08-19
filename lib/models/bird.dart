import 'package:hive/hive.dart';

//Class for bird now utilizes hive adapter

part 'bird.g.dart';

@HiveType(typeId: 0)
class Bird {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String species;
  @HiveField(5)
  final DateTime? hatchDate;
  @HiveField(3)
  final String gender;
  @HiveField(4)
  final String? imagePath;
  @HiveField(6)
  final String? cageNumber;
  @HiveField(7)
  final String? bandNumber;
  @HiveField(8)
  final String id;
  @HiveField(9)
  final String? sireId;
  @HiveField(10)
  final String? damId;

  Bird({
    String? id,
    required this.name,
    required this.species,
    this.hatchDate,
    required this.gender,
    this.imagePath,
    this.cageNumber,
    this.bandNumber,
    this.sireId,
    this.damId,
  }) : id =
           id ??
           DateTime.now().microsecondsSinceEpoch
               .toString(); //turns created time to a unique number

  String get displayAge {
    if (hatchDate == null) return 'Unknown';
    final days = DateTime.now().difference(hatchDate!).inDays;
    if (days < 0) return '0 days';
    if (days < 30) return '$days Days';
    final months = days ~/ 30;
    if (months < 12) return "$months Months";
    final years = months ~/ 12;
    final left = months % 12;
    return left == 0 ? "$years Years" : "$years Years $left Months";
  }
}
