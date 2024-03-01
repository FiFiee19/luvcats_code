import 'package:flutter/material.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
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
          return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if any
        } else if (snapshot.hasData) {
          // Extract data from snapshot
          final cats = snapshot.data ?? [];
          final totalCats = cats.length;
          final adoptedCats = cats.where((cat) => cat.status == 'yes').length;
          final waitingCats = totalCats - adoptedCats;

          // Build the widget with actual data
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
          return Text('No data available'); // Show this message if no data is available
        }
      },
    );
  }

  Widget _buildDashboardTile({required String title, required int count, required IconData iconData}) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red, // Match the color with your theme
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
