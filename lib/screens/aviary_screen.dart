import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:featherflow/screens/add_bird_screen.dart';
import 'bird_detail_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:featherflow/data/species_presets.dart';

/// The main dashboard screen
///
/// This 'AviaryScreen' and it dispalys the list of birds in local hive database
/// and provides access to the ADD, EDIT and BIRD ADDITIONAL DISPLAY views.

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  late Box<Bird> birdBox;

  @override
  void initState() {
    super.initState();
    //Grab the already loaded Hive Box. We dont load it here cuz
    //the main.dart handles the async initialization before the app starts
    birdBox = Hive.box<Bird>('Birds');
  }

  ///Opens the Edit bird menu for an existing bird
  ///
  /// The builder is dialog is wrapped in a StatefulBuilder because a standard AlertDialog is Stateless. Without it, picking a
  /// new date or choosin a parent form the dropdown wont work as nothing would be updated visually untill the dialog is closed and reopened.
  void _showEditDialog(Bird bird) {
    //The Controllers are assigned already existing bird data
    final nameController = TextEditingController(text: bird.name);
    final cageController = TextEditingController(text: bird.cageNumber ?? '');
    final bandController = TextEditingController(text: bird.bandNumber ?? '');
    String? selectedGender = bird.gender;
    TextEditingController? speciesController;
    String? pickedImagePath = bird.imagePath;
    DateTime? pickedHatchDate = bird.hatchDate;
    final genders = ['Male', 'Female', 'Unknown'];
    //Lineage state
    String? selectedSireId = bird.sireId;
    String? selectedDamId = bird.damId;
    //this is the snapshot of all birds for the parents dropdown
    final allBirds = birdBox.values.toList();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          //checks if new image has been selected
          Future<void> _pickImage() async {
            final XFile? image = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              //Used setDialogSTate so only ehe dialog rebuilds in place of setState
              setDialogState(() => pickedImagePath = image.path);
            }
          }

          Future<void> _pickedHatchDate() async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: pickedHatchDate ?? now,
              firstDate: DateTime(now.year - 100, 1, 1),
              lastDate: now,
            );
            if (picked != null) {
              setDialogState(() => pickedHatchDate = picked);
            }
          }

          return AlertDialog(
            scrollable: true,
            title: const Text("Edit Bird", style: TextStyle(fontSize: 24)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Image selector
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
                        ? ColoredBox(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: Image.file(
                              File(pickedImagePath!),
                              fit: BoxFit.contain,
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
                //BASIC INPUT FIELDS
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  //keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                // Autocomplete suggests species as user types to prevent typos
                Autocomplete<String>(
                  initialValue: TextEditingValue(text: bird.species),
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
                          decoration: const InputDecoration(
                            labelText: 'Species',
                          ),
                        );
                      },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                //GENDER AND ADDITIONAL DATA
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedGender = val),
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
                //LINEAGE SELECTION DROPDOWNS
                const SizedBox(height: 22),
                DropdownButtonFormField<String>(
                  value: selectedSireId,
                  decoration: const InputDecoration(labelText: 'Sire (Father)'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('None / Unknown'),
                    ),
                    //FILTER: must be male and bird cannot be its own father
                    ...allBirds
                        .where((b) => b.id != bird.id && b.gender == 'Male')
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
                      //FILTER: must be female and bird cannot be its own mother
                    ),
                    ...allBirds
                        .where((b) => b.id != bird.id && b.gender == 'Female')
                        .map(
                          (b) => DropdownMenuItem(
                            value: b.id,
                            child: Text('${b.name} (${b.species})'),
                          ),
                        ),
                  ],
                  onChanged: (val) => setState(() => selectedDamId = val),
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
                  //birds current index is found and ovrwritten to update hive
                  final birdslist = birdBox.values.toList();
                  int index = birdslist.indexOf(bird);
                  final speciesText = speciesController?.text.trim() ?? '';
                  Bird updated = Bird(
                    name: nameController.text,
                    species: speciesText,
                    hatchDate: pickedHatchDate,
                    gender: selectedGender!,
                    imagePath: pickedImagePath,
                    cageNumber: cageController.text.trim().isEmpty
                        ? null
                        : cageController.text.trim(),
                    bandNumber: bandController.text.trim().isEmpty
                        ? null
                        : bandController.text.trim(),
                    //Ensures the ID doesent changes so lineage doesent break
                    id: bird.id,
                    sireId: selectedSireId,
                    damId: selectedDamId,
                  );
                  birdBox.putAt(index, updated);
                  //Rebuild the main background sceen to show the updated data
                  setState(() {});
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

  ///Builds the main aviary list
  ///
  ///uses an expanded widget so the list takes up the whole of screeen
  /// below the header. This is crucial so the ListView knows its limits and can scroll properly

  @override
  Widget build(BuildContext context) {
    final birds = birdBox.values.toList();
    return Scaffold(
      body: Column(
        children: [
          //CUSTOM HEADER
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              /*borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),*/
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
          // checks if bird or empty list
          Expanded(
            //if database is empty itll show the welcome screen otherwise the list of birds will be shown.
            child: birds.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
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
                            birdBox.deleteAt(index);
                            setState(() {});
                          },
                          onEdit: () {
                            _showEditDialog(bird);
                          },
                        ),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //BIRD IMAGE AND BADGES
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 220,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
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
                                      //overlay the badges if cage/band data exists
                                      if (bird.cageNumber != null ||
                                          bird.bandNumber != null)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (bird.cageNumber != null)
                                                _buildBadge(
                                                  'Cage',
                                                  bird.cageNumber!,
                                                ),
                                              if (bird.bandNumber != null)
                                                _buildBadge(
                                                  'Band',
                                                  bird.bandNumber!,
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              //BIRD TEXT DATA
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bird.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${bird.species} | ${bird.displayAge} | ${bird.gender}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
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
          //Wait for the add bird screen to close and return the new bird object
          final newBird = await Navigator.push<Bird>(
            context,
            MaterialPageRoute(builder: (context) => const AddBirdScreen()),
          );
          if (newBird != null) {
            birdBox.add(newBird);
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// Builds the Welcome screen
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flutter_dash,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your aviary is empty',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first bird to start tracking cages,bands, and lineage.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final newBird = await Navigator.push<Bird>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddBirdScreen(),
                  ),
                );
                if (newBird != null) {
                  birdBox.add(newBird);
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add your first Bird'),
            ),
          ],
        ),
      ),
    );
  }

  //aides in building the small pill badges over the bird image.
  Widget _buildBadge(String label, String value) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
