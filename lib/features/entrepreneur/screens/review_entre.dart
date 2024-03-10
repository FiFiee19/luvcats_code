import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/review.dart';

class ReviewEntre extends StatefulWidget {
  // final Cathotel cathotel;
  final String cathotel;
  const ReviewEntre({
    Key? key,
    // required this.cathotel,
    required this.cathotel,
  }) : super(key: key);

  @override
  State<ReviewEntre> createState() => _ReviewEntreState();
}

class _ReviewEntreState extends State<ReviewEntre> {
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
      reviews = await cathotelServices.fetchReviews(context, widget.cathotel);
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
      setState(() {
        isLoading = true;
      });
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
                  if (reviews.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: Text(
                        'ยังไม่มีการให้คะแนน', // แสดงค่าเฉลี่ยทศนิยมหนึ่งตำแหน่ง
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (reviews.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        calculateAverageRating().toStringAsFixed(
                            1), // แสดงค่าเฉลี่ยทศนิยมหนึ่งตำแหน่ง
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (reviews.isNotEmpty)
                    RatingBar.builder(
                      initialRating: calculateAverageRating(),
                      ignoreGestures: true,
                      // minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                              padding:
                                  const EdgeInsets.only(left: 30, bottom: 20),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding:
                                            const EdgeInsets.only(left: 30),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            )));
  }
}
