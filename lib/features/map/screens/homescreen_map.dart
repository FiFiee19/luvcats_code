import 'package:flutter/material.dart';
import 'package:luvcats_app/features/map/screens/hospitalmapscreen.dart';
import 'package:luvcats_app/features/map/screens/storemapscreen.dart';

class HomeScreenMap extends StatefulWidget {
  const HomeScreenMap({super.key});

  @override
  State<HomeScreenMap> createState() => _HomeScreenMapState();
}

class _HomeScreenMapState extends State<HomeScreenMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonTheme(
              minWidth: double.infinity, // To make the button full width
              height: 60.0, // Adjust the height to your preference
              child: OutlinedButton.icon(
                icon: Icon(Icons.local_hospital, color: Colors.black),
                label: Text(
                  'โรงพยาบาลสัตว์',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        20, // Increase font size for better visibility on large buttons
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HospitalMapScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // This removes the rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40), // Add vertical padding
                ),
              ),
            ),
            SizedBox(height: 20),
            ButtonTheme(
              minWidth: double.infinity, // To make the button full width
              height: 60.0, // Adjust the height to your preference
              child: OutlinedButton.icon(
                icon: Icon(Icons.store, color: Colors.black),
                label: Text(
                  'ร้านขายของสัตว์',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        20, // Increase font size for better visibility on large buttons
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoreMapScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // This removes the rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40), // Add vertical padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
