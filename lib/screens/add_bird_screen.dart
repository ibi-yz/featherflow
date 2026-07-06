import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';

class AddBirdScreen extends StatefulWidget {
  const AddBirdScreen({super.key});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  //labelling controllers
  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  //disposing variables so crash doesent happens
  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }

  void saveBird() {
    final newBird = Bird(
      name: nameController.text,
      species: speciesController.text,
      age: ageController.text,
      gender: genderController.text,
    );
    Navigator.pop(context, newBird);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
