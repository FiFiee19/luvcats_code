import 'package:flutter/material.dart';
import 'package:luvcats_app/features/map/screens/mapscreen.dart';

class HomeScreenMap extends StatefulWidget {
  const HomeScreenMap({super.key});

  @override
  State<HomeScreenMap> createState() => _HomeScreenMapState();
}

class _HomeScreenMapState extends State<HomeScreenMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    Center(
      child: ElevatedButton(
                child: Text(
                  'Map',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                  
                },
                style: ElevatedButton.styleFrom( backgroundColor: Colors.grey),
              ),
    ),);
  }
}