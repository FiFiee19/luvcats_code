import 'package:flutter/material.dart';
import 'package:luvcats_app/models/cathotel.dart';

class RankOfCathotel extends StatelessWidget {
  final Future<List<Cathotel>> cathotel;

//แย่มาก ไม่ดี ปลานกลาง ดี ดีมาก
  RankOfCathotel({
    Key? key,
    required this.cathotel,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return // Inside your DashboardEntre's build method
FutureBuilder<List<Cathotel>>(
  future: cathotel,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      List<Cathotel> rankedCathotels = snapshot.data!;
      return ListView.builder(
        itemCount: rankedCathotels.length,
        itemBuilder: (context, index) {
          Cathotel cathotel = rankedCathotels[index];
          return ListTile(
            title: Text(cathotel.user!.username),
            subtitle: Text('Average rating: ${cathotel.reviews}'),
            // Add other UI elements to display Cathotel data
          );
        },
      );
    } else {
      return Text('No cathotels found');
    }
  },
);

  }
}