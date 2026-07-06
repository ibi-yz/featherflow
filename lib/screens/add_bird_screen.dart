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
    if (nameController.text.trim().isEmpty ||
        speciesController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty')));
      return;
    }
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
    return Scaffold(
      appBar: AppBar(title: Text('Add new Bird')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name:'),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: speciesController,
              decoration: const InputDecoration(labelText: 'Species:'),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age:'),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender:'),
            ),
            const SizedBox(height: 22),
            //adding return to main menu button
            ElevatedButton(onPressed: saveBird, child: Text('Save data')),
          ],
        ),
      ),
    );
  }
}
