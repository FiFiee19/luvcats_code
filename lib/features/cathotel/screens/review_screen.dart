import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _sendReviewFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: messageController,
                    scrollPadding: const EdgeInsets.all(20.0),
                    decoration: InputDecoration(
                      hintText: "แสดงความคิดเห็น",
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
                        return 'กรุณาแสดงความคิดเห็น';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  TextFormField(
                    controller: ratingController,
                    scrollPadding: const EdgeInsets.all(20.0),
                    decoration: InputDecoration(
                      hintText: "คะแนน",
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
                        return 'กรุณาให้คะแนน';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  SizedBox(height: 10),
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
      ),
    );
  }
}
