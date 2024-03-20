import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/review.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Notification_Entre extends StatefulWidget {
  const Notification_Entre({super.key});

  @override
  State<Notification_Entre> createState() => _Notification_EntreState();
}

class _Notification_EntreState extends State<Notification_Entre> {
  final CathotelServices cathotelServices = CathotelServices();
  List<Review>? reviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    fetchReview(userId);
  }

  Future<void> fetchReview(String userId) async {
    try {
      var fetchedReviews =
          await cathotelServices.fetchReviewsUser(context, userId);
      if (mounted) {
        setState(() {
          reviews = fetchedReviews;
          reviews?.sort((a, b) => DateTime.parse(b.createdAt!)
              .compareTo(DateTime.parse(a.createdAt!)));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (reviews == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (reviews!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: Text(
            'ไม่มีการรีวิว',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: () => fetchReview(userId),
          child: ListView.builder(
            itemCount: reviews!.length,
            itemBuilder: (context, index) {
              final reviewData = reviews![index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    NetworkImage(reviewData.user!.imagesP),
                                radius: 15,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                reviewData.user!.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 40, bottom: 10),
                            child: Row(
                              children: [
                                Text('รีวิวร้านของคุณ'),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('"'),
                                Text(
                                  reviewData.message.length > 10
                                      ? "${reviewData.message.substring(0, 10)}..."
                                      : reviewData.message,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text('"'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: RatingBar.builder(
                              initialRating: reviewData.rating,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 15.0,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 10),
                                child: Text(
                                  formatDateTime(reviewData.createdAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
