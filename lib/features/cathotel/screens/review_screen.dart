import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/review.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

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
  final _sendReviewFormKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final cathotelServices = CathotelServices();
  bool isLoading = true;

  List<Review> reviews = [];
  @override
  void initState() {
    super.initState();
    loadReviews();
    print(widget.cathotel.id);
  }

  Future<void> loadReviews() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.cathotel.id != null) {
        reviews =
            await cathotelServices.fetchReviews(context, widget.cathotel.id);
        print(reviews);
      } else {
        print("Post ID is null");
      }
    } catch (e) {
      print(e.toString());
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addReview() async {
    print("Attempting to add comment"); // Debugging statement
    if (_sendReviewFormKey.currentState?.validate() ?? false) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      await cathotelServices.addReview(
        user_id: userId,
        context: context,
        message: messageController.text,
        rating: double.parse(ratingController.text),
        cathotelId: widget.cathotel.id,
      );
    }
  }

  @override
  void dispose() {
    if (mounted) {
      messageController.dispose();
      ratingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'ให้คะแนน',style: TextStyle(color: Colors.black),
      ),
      
    ),
      body: Column(
        children: [
          Form(
            key: _sendReviewFormKey,
            child: Column(
              children: [
                 SizedBox(height: 50,),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingController.text =
                        rating.toString(); // อัปเดตค่าใน ratingController
                  },
                ),
                SizedBox(height: 50,),
                Divider(),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: messageController,
                    scrollPadding: const EdgeInsets.all(20.0),
                    maxLines: 7,
                    decoration: InputDecoration(
                      hintText: "เขียนรีวิว",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'กรุณาเขียนรีวิว';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                ),
                
                SizedBox(height: 20),
                CustomButton(
                  text: 'ส่ง',
                  onTap: () {
                    if (_sendReviewFormKey.currentState!.validate()) {
                      addReview(); // Call addComment only if the form is valid
                      messageController.clear();
                      ratingController
                          .clear(); // Clear the text field after sending the comment
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
