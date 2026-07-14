import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:featherflow/screens/add_bird_screen.dart';
import 'bird_detail_screen.dart';

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  final List<Bird> birds = [
    /*Bird(name: 'Banana', species: 'Budgie', age: '3 months', gender: 'male'),
    Bird(name: 'Apple', species: 'Cockatiel', age: '1 year', gender: 'Female'),
    Bird(
      name: 'Einstein',
      species: "Congo African Grey",
      age: '7 year',
      gender: 'male',
    )*/
  ];

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
                  onTap: () => BirdDetailsSheet.show(context, bird),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(child: Icon(Icons.flutter_dash)),
                      title: Text(bird.name),
                      subtitle: Text(
                        '${bird.species} | ${bird.age} | ${bird.gender}',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
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
