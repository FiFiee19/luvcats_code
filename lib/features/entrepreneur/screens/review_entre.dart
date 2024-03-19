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
  final TextEditingController replyController = TextEditingController();
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

  Future<void> showReplyDialog(BuildContext context, String reviewId) async {
    final TextEditingController replyController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Set to true for better UX
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ตอบกลับรีวิว'),
          content: TextField(
            controller: replyController,
            decoration:
                InputDecoration(hintText: "กรอกข้อความตอบกลับที่นี่..."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ส่ง'),
              onPressed: () async {
                final message = replyController.text;
                // Ensure the reply message is not empty before sending
                if (message.trim().isNotEmpty) {
                  await cathotelServices.replyToReview(
                    context: context,
                    reviewId: reviewId,
                    replyMessage: message,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('กรุณากรอกข้อความตอบกลับ'),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
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
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, bottom: 20),
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
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6, bottom: 10),
                                            child: Text(
                                              review.createdAt != null
                                                  ? DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          review.createdAt!))
                                                  : 'ไม่ทราบวันที่',
                                            ),
                                          ),
                                          Spacer(),
                                          if (review.reply == null)
                                            Padding(
                                              padding: EdgeInsets.only(),
                                              child: TextButton(
                                                child: Text('ตอบกลับ'),
                                                onPressed: () {
                                                  // Call the dialog with the current review's ID
                                                  showReplyDialog(
                                                      context, review.id!);
                                                },
                                              ),
                                            )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: review.reply !=
                                                null // Check if reply is not null
                                            ? Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 8.0, 18.0, 8.0),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 216, 212, 212),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                                      review.reply!
                                                          .message, // We can safely use the bang operator now
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox
                                                .shrink(), // If reply is null, display nothing
                                      ),
                                      Divider(),
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
