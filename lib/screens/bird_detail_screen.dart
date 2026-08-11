import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'dart:io';

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

    return Padding(
      padding: const EdgeInsets.all(24),
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
    );
  }

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
}
