import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}



class _AviaryScreenState extends State<AviaryScreen> {
  final List<Bird> birds = [
    Bird(name: 'Banana', species: 'Budgie', age: '3 months', gender: 'male'),
    Bird(name: 'Apple', species: 'Cockatiel', age: '1 year', gender: 'Female'),
    Bird(name: 'Einstein', species: "Congo African Grey", age: '7 year', gender: 'male'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Aviary'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: birds.length,
        itemBuilder: (context, index){
          final Bird = birds[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.flutter_dash),),
              title: Text(Bird.name),
              subtitle: Text('${Bird.species} | ${Bird.age} | ${Bird.gender}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 22,),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Text('button working ');},
        child: Icon(Icons.add),
      ),
    );
  }
}