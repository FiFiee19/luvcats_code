import 'package:flutter/material.dart';
import 'package:luvcats_app/models/review.dart';

class DashboardEntre extends StatelessWidget {
  final Future<List<Review>> reviews;

//แย่มาก ไม่ดี ปลานกลาง ดี ดีมาก
  DashboardEntre({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  String ratingMessage(double avgRating) {
    if (avgRating <= 1) {
      return "แย่มาก";
    } else if (avgRating <= 2) {
      return "ไม่ดี";
    } else if (avgRating <= 3) {
      return "ปานกลาง";
    } else if (avgRating <= 4) {
      return "ดี";
    } else {
      return "ดีมาก";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: reviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final reviews = snapshot.data ?? [];

          final double avgRating = reviews.isNotEmpty
              ? reviews
                      .map((review) => double.parse(review.rating.toString()))
                      .reduce((a, b) => a + b) /
                  reviews.length
              : 0.0;

          return Column(
            children: [
              Card(
                margin: EdgeInsets.all(20.0),
                elevation: 4, // Adjust elevation for shadow
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Rounded corners for card
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // To constrain the Row's size to its children
                          children: [
                            Icon(
                              Icons.star, // Replace with your preferred icon
                              color: Colors.amber, // Icon color
                              size: 24.0, // Icon size
                            ),
                            SizedBox(
                                width: 8.0), // Spacing between icon and text
                            Text(
                              'รีวิวโดยรวม',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Rating message container
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Text(
                            ratingMessage(avgRating),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
