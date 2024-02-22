import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luvcats_app/features/cathotel/screens/review_screen.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/poststraycat.dart';
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
    loadReviews();
    print(widget.cathotel.id);
    print(widget.cathotel.id.runtimeType);
  }

  Future<void> loadReviews() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.cathotel.id != null) {
        var fetchedReviews =
            await cathotelServices.fetchReviews(context, widget.cathotel.id);
        if (mounted) {
          setState(() {
            isLoading = false;
            reviews = fetchedReviews;
          });
        }
      } else {
        print("Cathotel ID is null");
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  var selectedItem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CustomCarouselSlider(
            images: widget.cathotel.images,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        widget.cathotel.user!.imagesP,
                      ),
                      radius: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.cathotel.user!.username,
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                                fontSize: 16),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "รายละเอียด: ",
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
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
                    style: Theme.of(context).textTheme.subtitle2!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                          ),
                        ),
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
                  "ราคา:  " + widget.cathotel.price.toString() + "/คืน",
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
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
                  "จังหวัด:  " + widget.cathotel.province,
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
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
                  "ช่องทางการติดต่อ: ",
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
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
                  widget.cathotel.contact,
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
                      ),
                ),
              ],
            ),
          ),
          //   Padding(
          //   padding: const EdgeInsets.only(left: 30, bottom: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "${widget.cathotel.reviews.length} ความคิดเห็น, รวมคะแนน: $calculateTotalRating",
          //         style: Theme.of(context).textTheme.subtitle2!.merge(
          //               TextStyle(
          //                 fontWeight: FontWeight.w700,
          //                 color: Colors.black,
          //               ),
          //             ),
          //       ),
          //       SizedBox(height: 10),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.cathotel.reviews.length} ความคิดเห็น",
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          ElevatedButton(
            child: Text(
              'รีวิว',
              style: TextStyle(
                color: Colors.black,
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
                setState(() {}); // บังคับให้ UI รีเฟรช
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.grey),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: reviews
          //       .map(
          //         (review) => Align(
          //           alignment: Alignment.centerLeft,
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 30, bottom: 20),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   children: [
          //                     CircleAvatar(
          //                         backgroundColor: Colors.grey,
          //                         backgroundImage: NetworkImage(
          //                           review.user!.imagesP,
          //                         ),
          //                         radius: 15),
          //                     SizedBox(width: 10),
          //                     Text(
          //                       review.user!.username,
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w700,
          //                         fontSize: 16,
          //                         color: Colors.grey.shade500,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.only(left: 40, bottom: 10),
          //                   child: Text(
          //                     review.message,
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                     ),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.only(left: 40, bottom: 10),
          //                   child: Text(
          //                     review.createdAt != null
          //                         ? DateFormat('yyyy-MM-dd – kk:mm')
          //                             .format(DateTime.parse(review.createdAt!))
          //                         : 'ไม่ทราบวันที่',
          //                   ),
          //                 ),

          //               ],
          //             ),
          //           ),
          //         ),
          //       )
          //       .toList(),
          // ),
        ],
      )),
    );
  }
}
