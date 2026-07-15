import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';

class BirdDetailsSheet extends StatelessWidget {
  final Bird bird;
  const BirdDetailsSheet({super.key, required this.bird});

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
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: ColorScheme.primaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(bird.name, style: TextTheme.headlineMedium),
          Text(
            '${bird.species} | ${bird.age} | ${bird.gender}',
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
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    //later add edit bird option
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

  static void show(BuildContext context, Bird bird) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: BirdDetailsSheet(bird: bird),
      ),
    );
  }
}
