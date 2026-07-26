import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:image_picker/image_picker.dart';

class AddBirdScreen extends StatefulWidget {
  const AddBirdScreen({super.key});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  //labelling controllers
  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  final ageNumberController = TextEditingController();
  String? selectedGender;
  String? selectedUnit;
  String? pickedImagePath;
  final genders = ['Male', 'Female', 'Unknown'];
  final units = ['Days', "Months", "Years"];

  //disposing variables so crash doesent happens
  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
    ageNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() => pickedImagePath = image.path);
    }
  }

  void saveBird() {
    if (nameController.text.trim().isEmpty ||
        speciesController.text.trim().isEmpty ||
        ageNumberController.text.trim().isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty')));
      return;
    }
    final newBird = Bird(
      name: nameController.text,
      species: speciesController.text,
      age: '${ageNumberController.text.trim()} $selectedUnit',
      gender: selectedGender!,
      imagePath: pickedImagePath,
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
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: ageNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Age;"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedUnit,
                    decoration: const InputDecoration(labelText: 'Unit:'),
                    items: units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedUnit = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => setState(() => selectedGender = val),
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
