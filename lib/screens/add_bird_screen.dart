import 'package:featherflow/data/species_presets.dart';
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
  final cageController = TextEditingController();
  final bandController = TextEditingController();
  TextEditingController? speciesController;
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
    cageController.dispose();
    bandController.dispose();
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
    final speciesText = speciesController?.text.trim() ?? '';
    if (nameController.text.trim().isEmpty ||
        speciesText.isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty')));
      return;
    }
    final newBird = Bird(
      name: nameController.text,
      species: speciesText,
      gender: selectedGender!,
      imagePath: pickedImagePath,
      hatchDate: pickedHatchDate,
      cageNumber: cageController.text.trim().isEmpty
          ? null
          : cageController.text.trim(),
      bandNumber: bandController.text.trim().isEmpty
          ? null
          : bandController.text.trim(),
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
                  height: pickedImagePath != null ? 200 : 70,
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
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) return speciesPresets;
                  return speciesPresets.where(
                    (s) => s.toLowerCase().contains(value.text.toLowerCase()),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      speciesController = controller;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (value) => onFieldSubmitted(),
                        decoration: const InputDecoration(labelText: 'Species'),
                      );
                    },
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
              TextField(
                controller: cageController,
                decoration: const InputDecoration(
                  labelText: 'Cage number(optional)',
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: bandController,
                decoration: const InputDecoration(
                  labelText: 'Band number(optional)',
                ),
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
