import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/aviary_screen.dart';


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







