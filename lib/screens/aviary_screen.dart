import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:featherflow/screens/add_bird_screen.dart';
import 'bird_detail_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  final List<Bird> birds = [];
  void _showEditDialog(Bird bird) {
    final nameController = TextEditingController(text: bird.name);
    final speciesController = TextEditingController(text: bird.species);
    final ageNumberController = TextEditingController();
    String? selectedGender = bird.gender;
    String? selectedUnit;
    String? pickedImagePath = bird.imagePath;
    final genders = ['Male', 'Female', 'Unknown'];
    final units = ['Days', "Months", "Years"];

    final parts = bird.age.trim().split(' ');
    if (parts.length > 1 && units.contains(parts.last)) {
      selectedUnit = parts.last;
      ageNumberController.text = parts.sublist(0, parts.length - 1).join(' ');
    } else {
      ageNumberController.text = bird.age;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> _pickImage() async {
            final XFile? image = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              setDialogState(() => pickedImagePath = image.path);
            }
          }

          return AlertDialog(
            scrollable: true,
            title: const Text("Edit Bird", style: TextStyle(fontSize: 24)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //here i will add edit bird image
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
                  //keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: speciesController,
                  //keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Species'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: ageNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Age'),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: const InputDecoration(labelText: 'Age'),
                        items: units
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setDialogState(() => selectedUnit = val),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedGender = val),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  int index = birds.indexOf(bird);
                  Bird updated = Bird(
                    name: nameController.text,
                    species: speciesController.text,
                    age:
                        '${ageNumberController.text.trim()} ${selectedUnit ?? ''}'
                            .trim(),
                    gender: selectedGender!,
                    imagePath: pickedImagePath,
                  );
                  setState(() {
                    birds[index] = updated;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          'DIGITAL AVIARY',
          style: TextStyle(
            fontFamily: 'Unique',
            fontSize: 64,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      )*/
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 23,
              bottom: 20,
            ),
            child: Text(
              'DIGITAL AVIARY',
              style: TextStyle(
                fontFamily: 'Unique',
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                height: 1.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12),
              itemCount: birds.length,
              itemBuilder: (context, index) {
                final bird = birds[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => BirdDetailsSheet.show(
                    context,
                    bird: bird,
                    onDelete: () {
                      setState(() {
                        birds.remove(bird);
                      });
                    },
                    onEdit: () {
                      _showEditDialog(bird);
                    },
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 140,
                            child: bird.imagePath != null
                                ? Image.file(
                                    File(bird.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.flutter_dash,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bird.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${bird.species} | ${bird.age} | ${bird.gender}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBird = await Navigator.push<Bird>(
            context,
            MaterialPageRoute(builder: (context) => const AddBirdScreen()),
          );
          if (newBird != null) {
            setState(() {
              birds.add(newBird);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
