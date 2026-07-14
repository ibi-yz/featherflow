import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';

class BirdDetailsSheet extends StatelessWidget {
  final Bird bird;
  const BirdDetailsSheet({super.key, required this.bird});

  static void show(BuildContext context, Bird bird) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => BirdDetailsSheet(bird: bird),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Text(bird.name));
  }
}
