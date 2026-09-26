import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'dart:io';
import 'aviary_screen.dart';
import 'package:hive/hive.dart';

/// A bottom sheet that shows all the detailed info for the selected bird
///
/// its a stateless widget cuz it only shows the data passed to it
/// its got the bird pic, cage/band abdges, and the lineage

class BirdDetailsSheet extends StatelessWidget {
  final Bird bird;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const BirdDetailsSheet({
    super.key,
    required this.bird,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme = Theme.of(context).textTheme;
    final ColorScheme = Theme.of(context).colorScheme;
    //load all the birds into memory so they can be searched through for the lineage
    final allBirds = Hive.box<Bird>('Birds').values.toList();
    //searches through the aviary with the provided ID and return the full matching bird object
    Bird? findBird(String? id) {
      if (id == null) return null;
      for (final b in allBirds) {
        if (b.id == id) return b;
      }
      return null;
    }

    // resolve the parents
    final sire = findBird(bird.sireId);
    final dam = findBird(bird.damId);
    final children = allBirds
        .where((b) => b.sireId == bird.id || b.damId == bird.id)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      //Single child scroll view stops the overflow errorr
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(24),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: bird.imagePath != null
                    ? ColoredBox(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: Image.file(
                          File(bird.imagePath!),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.flutter_dash,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(bird.name, style: TextTheme.headlineMedium),
            Text(
              '${bird.species} | ${bird.displayAge} | ${bird.gender}',
              style: TextTheme.bodyMedium?.copyWith(
                color: ColorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (bird.cageNumber != null)
                  _buildBadge(context, 'Cage', bird.cageNumber!),
                if (bird.bandNumber != null)
                  _buildBadge(context, 'Band', bird.bandNumber!),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            //lineage text section
            Text(
              'Lineage',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            //?.name means 'try to grab the name if it exits'
            //otherwise output unknown so it doesent crash
            Text(
              'Sire (Father): ${sire?.name ?? 'Unknown'}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Dam (Mother): ${dam?.name ?? 'Unknown'}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            if (children.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'OffSpring (${children.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              //map builds only one text widget per baby then unpcks them into list
              ...children.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${c.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      //later add delete option
                      Navigator.pop(context);
                      onDelete();
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ColorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                    label: Text("Edit"),
                    icon: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Static method so the main aviary screen can call for it like a pop up function
  static void show(
    BuildContext context, {
    required Bird bird,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: BirdDetailsSheet(bird: bird, onDelete: onDelete, onEdit: onEdit),
      ),
    );
  }

  //builds the cage/band badges
  Widget _buildBadge(BuildContext context, label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
