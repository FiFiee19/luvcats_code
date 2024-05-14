import 'package:flutter/material.dart';
import 'package:luvcats_app/models/poststraycat.dart';

class DashboardStraycat extends StatelessWidget {
  final Future<List<Straycat>> catData;

  DashboardStraycat({
    Key? key,
    required this.catData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Straycat>>(
      future: catData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final cats = snapshot.data ?? [];
          final totalCats = cats.length;
          final adoptedCats = cats.where((cat) => cat.status == 'yes').length;
          final waitingCats = totalCats - adoptedCats;

          return Column(
            children: [
              _buildDashboardTile(
                title: 'จำนวนแมวทั้งหมด',
                count: totalCats,
                iconData: Icons.pets,
              ),
              _buildDashboardTile(
                title: 'แมวที่ได้บ้านแล้ว',
                count: adoptedCats,
                iconData: Icons.home,
              ),
              _buildDashboardTile(
                title: 'แมวที่ยังรอบ้าน',
                count: waitingCats,
                iconData: Icons.hourglass_empty,
              ),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildDashboardTile(
      {required String title, required int count, required IconData iconData}) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
