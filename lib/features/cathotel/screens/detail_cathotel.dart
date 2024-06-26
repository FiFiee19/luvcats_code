import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:luvcats_app/features/cathotel/screens/forms_review.dart';
import 'package:luvcats_app/features/cathotel/screens/review_screen.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/review.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';

class DetailCathotelScreen extends StatefulWidget {
  final Cathotel cathotel;
  const DetailCathotelScreen({
    Key? key,
    required this.cathotel,
  }) : super(key: key);

  @override
  State<DetailCathotelScreen> createState() => _DetailCathotelScreenState();
}

class _DetailCathotelScreenState extends State<DetailCathotelScreen> {
  final CathotelServices cathotelServices = CathotelServices();
  bool isLoading = true;
  double totalRating = 0.0;

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
      if (mounted) {
        setState(() {
          reviews;
          totalRating = calculateAverageRating();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: fetchReviews,
        child: SingleChildScrollView(
            child: Column(
          children: [
            CustomCarouselSlider(
              images: widget.cathotel.images,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          widget.cathotel.user!.imagesP,
                        ),
                        radius: 16,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.cathotel.user!.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "รายละเอียด: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.cathotel.description,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ราคา:  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.cathotel.price.toString() + "/คืน",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "จังหวัด:  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.cathotel.province,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ช่องทางการติดต่อ: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.cathotel.contact,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (widget.cathotel.reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Text(
                  'ยังไม่มีการให้คะแนน',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            if (widget.cathotel.reviews.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  calculateAverageRating().toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            if (widget.cathotel.reviews.isNotEmpty)
              RatingBar.builder(
                initialRating: calculateAverageRating(),
                ignoreGestures: true,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            if (widget.cathotel.reviews.isNotEmpty)
              ElevatedButton(
                child: Text(
                  'ดูรีวิว',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReviewScreen(cathotel: widget.cathotel)),
                  );
                  if (result != null) {
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            if (widget.cathotel.reviews.isEmpty)
              ElevatedButton(
                child: Text(
                  'เริ่มรีวิว!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FormsReview(cathotel: widget.cathotel),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        )),
      ),
    );
  }
}
