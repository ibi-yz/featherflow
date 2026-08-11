import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBirdScreen extends StatefulWidget {
  const AddBirdScreen({super.key});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  //labelling controllers
  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  String? selectedGender;
  String? pickedImagePath;
  final genders = ['Male', 'Female', 'Unknown'];
  DateTime? pickedHatchDate;

  Future<void> _pickedHatchDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: pickedHatchDate ?? now,
      firstDate: DateTime(now.year - 100, 1, 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => pickedHatchDate = picked);
    }
  }

  //disposing variables so crash doesent happens
  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
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
        selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty')));
      return;
    }
    final newBird = Bird(
      name: nameController.text,
      species: speciesController.text,
      gender: selectedGender!,
      imagePath: pickedImagePath,
      hatchDate: pickedHatchDate,
    );
    Navigator.pop(context, newBird);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new Bird')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: pickedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(pickedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add a photo',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
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
              InkWell(
                onTap: _pickedHatchDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        pickedHatchDate == null
                            ? 'Tap to set date of birth'
                            : 'Born: ${pickedHatchDate!.day}/${pickedHatchDate!.month}/${pickedHatchDate!.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}
