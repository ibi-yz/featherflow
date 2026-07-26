//custom class for digital aviary

class Bird {
  final String name;
  final String species;
  final String age;
  final String gender;
  String? imagePath;

  Bird({
    required this.name,
    required this.species,
    required this.age,
    required this.gender,
    this.imagePath,
  });
}
