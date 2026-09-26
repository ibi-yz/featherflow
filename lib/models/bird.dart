import 'package:hive/hive.dart';

//This geenrated Hive adapter file

part 'bird.g.dart';

///represents a single bird in the hive database
//All fields are 'final' so a Bird object does not vary
//editing a bird does not change the exisitng object
//everyitme a new a new bird gets built and the old hive slot gets overwritten

@HiveType(typeId: 0)
class Bird {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String species;
  //field (2) to (4) are skipped as they were removed and hive doesent care.
  //the numbers only have to be unique and consistent
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

  //String ID is used for Lineage feature
  //Its a unique identifier for each bird that allows the parents and offsrping to be identified
  //It is created when a new bird is added to the list making it completely unique so no collisions take place

  @HiveField(8)
  final String id;
  @HiveField(9)
  //This is the fathers ID. which uses the STRING ID. This is nullable as often parents are unknown or not added to bird list
  final String? sireId;
  //This is the mothers ID. It is also nullable
  @HiveField(10)
  final String? damId;

  //THIS CONSTRUCTS A NEW BIRD
  //ID is intentionally nullable but the field isnt
  //Whenever hive is reloading an old bird, the saved ID is passed back.In case of new bird, a new ID is created
  //The components with 'required this." have to be present or else a bird is not valid
  // The rest even if not present dont cause an issue
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
  //This calculates the current age of the bird and it updates with time
  //The units depend on if a month, day or year is suitable
  String get displayAge {
    //If birthday isnt set just return 'UNknown"
    if (hatchDate == null) return 'Unknown';
    final days = DateTime.now().difference(hatchDate!).inDays;
    if (days < 0) return '0 days';
    if (days < 30) return '$days Days';
    final months = days ~/ 30;
    if (months < 12) return "$months Months";
    final years = months ~/ 12;
    final left = months % 12;
    //If there is an exact birthday, it will drop the 'O months' part
    return left == 0 ? "$years Years" : "$years Years $left Months";
  }
}
