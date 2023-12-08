import 'package:flutter/material.dart';

class Map_Cat extends StatefulWidget {
  const Map_Cat({super.key});

  @override
  State<Map_Cat> createState() => _Map_CatState();
}

class _Map_CatState extends State<Map_Cat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Map')),
    );
  }
}
