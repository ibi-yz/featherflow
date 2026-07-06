import 'package:flutter/material.dart';
import 'theme.dart';



void main() {
  runApp(const MyApp());
}
//stateless widget ibi, this is main thingy which contains materialapp which is concrete base
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: AviaryScreen(),
    );
  }
}


class AviaryScreen extends StatelessWidget {
  const AviaryScreen({super.key});

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




