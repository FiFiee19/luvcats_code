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
              minWidth: double.infinity, 
              height: 60.0, 
              child: OutlinedButton.icon(
                icon: Icon(Icons.local_hospital, color: Colors.black),
                label: Text(
                  'โรงพยาบาลสัตว์',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        20, 
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
                        10),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40),
                ),
              ),
            ),
            SizedBox(height: 20),
            ButtonTheme(
              minWidth: double.infinity, 
              height: 60.0, 
              child: OutlinedButton.icon(
                icon: Icon(Icons.store, color: Colors.black),
                label: Text(
                  'ร้านขายของสัตว์',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        20, 
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
                        10), 
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
