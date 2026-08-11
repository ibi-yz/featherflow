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
  String? imagePath;

  Bird({
    required this.name,
    required this.species,
    this.hatchDate,
    required this.gender,
    this.imagePath,
  });

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
