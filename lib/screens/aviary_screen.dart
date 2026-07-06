import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';
import 'package:featherflow/screens/add_bird_screen.dart';

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  final List<Bird> birds = [
    Bird(name: 'Banana', species: 'Budgie', age: '3 months', gender: 'male'),
    Bird(name: 'Apple', species: 'Cockatiel', age: '1 year', gender: 'Female'),
    Bird(
      name: 'Einstein',
      species: "Congo African Grey",
      age: '7 year',
      gender: 'male',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Aviary'), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: birds.length,
        itemBuilder: (context, index) {
          final bird = birds[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.flutter_dash)),
              title: Text(bird.name),
              subtitle: Text('${bird.species} | ${bird.age} | ${bird.gender}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 22),
            ),
          );
        },
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
