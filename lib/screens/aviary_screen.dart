import 'package:flutter/material.dart';
import 'package:featherflow/models/bird.dart';

class AviaryScreen extends StatefulWidget {
  const AviaryScreen({super.key});

  @override
  State<AviaryScreen> createState() => _AviaryScreenState();
}



class _AviaryScreenState extends State<AviaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Aviary'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.flutter_dash),
              ),
              title: Text('Banana'),
              subtitle: Text('Budgeriar | age: 3 months'),
              trailing: Icon(Icons.arrow_forward_ios, size: 22),
            ),
          ),
           Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.flutter_dash),
              ),
              title: Text('Apple'),
              subtitle: Text('Cockatiel | age: 8 months'),
              trailing: Icon(Icons.arrow_forward_ios, size: 22),
            ),
          ),
           Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.flutter_dash,),
              ),
              title: Text('Peach'),
              subtitle: Text('Ring Neck Parakeet | age: 2 years'),
              trailing: Icon(Icons.arrow_forward_ios, size: 22),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Text('button working '),
        child: Icon(Icons.add),
      ),
    );
  }
}