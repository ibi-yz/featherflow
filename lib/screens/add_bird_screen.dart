import 'package:featherflow/data/species_presets.dart';
import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';

///The screen for adding a new bird to the list
///
/// Unlike the edit screen which is a popup, this is a full page/screen
/// when save is hit, the bird is built and added to the list
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

  //nullable cuz autocomplete builds it later
  TextEditingController? speciesController;
  //variables that hold users selected choices. names speak for themselves.
  String? selectedGender;
  String? pickedImagePath;
  final genders = ['Male', 'Female', 'Unknown'];
  DateTime? pickedHatchDate;

  //lineage state
  String? selectedSireId;
  String? selectedDamId;

  //lsit of existing birds to populate the parents dropdowns.
  List<Bird> allBirds = [];

  @override
  void initState() {
    super.initState();
    //grab a snapshot of all birds so we can pick the parents from them
    allBirds = Hive.box<Bird>('Birds').values.toList();
  }

  //pops up the calender so user can selected the date of birth for birdy
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

  //opens the phone gallery so user can select a pic of their cute birdy
  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() => pickedImagePath = image.path);
    }
  }

  //validates and saves the bird
  void saveBird() {
    //validation: check if required fields are blank and if the user has entered extra spaces .trim deals with them
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
      // If optional text fields are empty, save null instead of an empty string
      cageNumber: cageController.text.trim().isEmpty
          ? null
          : cageController.text.trim(),
      bandNumber: bandController.text.trim().isEmpty
          ? null
          : bandController.text.trim(),
      sireId: selectedSireId,
      damId: selectedDamId,
    );
    //closes the screen and pushes back to main aviary screen
    Navigator.pop(context, newBird);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new Bird')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        //singlechildscrollview so the keyboard doesent hide the bottom text fields.
        child: SingleChildScrollView(
          child: Column(
            children: [
              //IMAGE PICKER
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
              //BASIC INFO FIELDS
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name:'),
              ),
              const SizedBox(height: 22),
              //Autocomplete suggests species as user types to prevent typos from a generous list in species_presets.dart
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
              //HATCHDATE
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
              //HAtch date and other stuff
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

              //Lineage selection dropdowns
              DropdownButtonFormField<String>(
                value: selectedSireId,
                decoration: const InputDecoration(labelText: 'Sire (Father)'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None / Unknown'),
                  ),
                  // FILTER: only show male birds
                  ...allBirds
                      .where((b) => b.gender == 'Male')
                      .map(
                        (b) => DropdownMenuItem(
                          value: b.id,
                          child: Text('${b.name} (${b.species})'),
                        ),
                      ),
                ],
                onChanged: (val) => setState(() => selectedSireId = val),
              ),
              const SizedBox(height: 22),
              DropdownButtonFormField<String>(
                value: selectedDamId,
                decoration: const InputDecoration(labelText: 'Dam (Mother)'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None / Unknown'),
                  ),
                  // FILTER: only show female birds
                  ...allBirds
                      .where((b) => b.gender == 'Female')
                      .map(
                        (b) => DropdownMenuItem(
                          value: b.id,
                          child: Text('${b.name} (${b.species})'),
                        ),
                      ),
                ],
                onChanged: (val) => setState(() => selectedDamId = val),
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
