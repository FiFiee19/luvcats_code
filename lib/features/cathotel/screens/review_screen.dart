import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/cathotel/screens/forms_review.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/review.dart';

class ReviewScreen extends StatefulWidget {
  final Cathotel cathotel;
  const ReviewScreen({
    Key? key,
    required this.cathotel,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final CathotelServices cathotelServices = CathotelServices();
  bool isLoading = true;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviews();
    calculateAverageRating();
  }

  Future<void> fetchReviews() async {
    try {
      reviews =
          await cathotelServices.fetchReviews(context, widget.cathotel.id);
    } catch (e) {
      print(e.toString());
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) {
      return 0.0;
    }
    double sum = 0;
    for (var i in reviews) {
      sum += double.parse(i.rating.toString());
    }
    return sum / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'รีวิว',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading
          ? const LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: fetchReviews,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    calculateAverageRating().toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                RatingBar.builder(
                  initialRating: calculateAverageRating(),
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "( ${reviews.length} )",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final reviewData = reviews[index];

                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            reviewData.user!.imagesP,
                                          ),
                                          radius: 15),
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
                                    padding: const EdgeInsets.only(left: 30),
                                    child: RatingBar.builder(
                                      initialRating: reviewData.rating,
                                      ignoreGestures: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, bottom: 10),
                                    child: Text(
                                      reviewData.message,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, bottom: 10),
                                    child: Text(
                                      formatDateTime(reviewData.createdAt),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: reviewData.reply != null
                                        ? Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 8.0, 18.0, 8.0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 216, 212, 212),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'การตอบกลับของร้าน',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  reviewData.reply!.message,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                              const Divider()
                            ],
                          ));
                    },
                  ),
                )
              ]),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormsReview(cathotel: widget.cathotel),
              ),
            );
          },
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
