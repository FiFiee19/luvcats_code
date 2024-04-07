import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
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
    loadReviews();
    calculateAverageRating();
  }

  Future<void> loadReviews() async {
    setState(() {
      isLoading = true;
    });
    try {
      reviews =
          await cathotelServices.fetchReviews(context, widget.cathotel.id);
      print(reviews);
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
    for (var review in reviews) {
      sum += double.parse(review.rating.toString());
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
      body: RefreshIndicator(
          onRefresh: loadReviews,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    calculateAverageRating()
                        .toStringAsFixed(1), 
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                RatingBar.builder(
                  initialRating: calculateAverageRating(),
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "( ${reviews.length} )",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reviews
                      .map(
                        (review) => Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
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
                                              review.user!.imagesP,
                                            ),
                                            radius: 15),
                                        SizedBox(width: 10),
                                        Text(
                                          review.user!.username,
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
                                        initialRating: review.rating,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, _) => Icon(
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
                                        review.message,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, bottom: 10),
                                      child: Text(
                                        review.createdAt != null
                                            ? DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    review.createdAt!))
                                            : 'ไม่ทราบวันที่',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: review.reply != null
                                          ? Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8.0, 18.0, 8.0),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 216, 212, 212),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'การตอบกลับของร้าน',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.0),
                                                  Text(
                                                    review.reply!.message,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox
                                              .shrink(), 
                                    ),
                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          child: const Icon(
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
