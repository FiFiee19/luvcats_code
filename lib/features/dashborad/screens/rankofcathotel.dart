// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
// // สมมติว่าคุณมีโมเดลสำหรับร้านและรีวิว
// import 'package:luvcats_app/models/cathotel.dart';
// import 'package:luvcats_app/models/review.dart';



// class DashboardRank extends StatefulWidget {
//   const DashboardRank({super.key});

//   @override
//   State<DashboardRank> createState() => _DashboardRankState();
// }

// class _DashboardRankState extends State<DashboardRank> {
//   Cathotel? cathotel;
//   List<Cathotel>? allcathotel;
//   final CathotelServices cathotelServices = CathotelServices();
//   @override
//   void initState() {
//     super.initState();
//     fetchAllCathotel();
//   }

//   //เรียกข้อมูลAllCathotelในcathotelServices
//   Future<void> fetchAllCathotel() async {
//     allcathotel = await cathotelServices.fetchAllCathotel(context);
//     double calculateAverageRating(List<Review> reviews) {
//       if (reviews.isEmpty) return 0.0;
//       double sum = reviews.fold(0.0, (sum, item) => sum + item.rating);
//       return  sum / reviews.length;
//     }
//     allcathotel?.sort((a, b) => b.calculateAverageRating().compareTo(a.averageRating));
    

//     if (mounted) {
//       setState(() {});
//     }
//   }
//   double calculateAverageRating(List<Review> reviews) {
//       if (reviews.isEmpty) return 0.0;
//       double sum = reviews.fold(0.0, (sum, item) => sum + item.rating);
//       return sum / reviews.length;
//     }

//   @override
//   Widget build(BuildContext context) {
//     if (allcathotel == null) {
//       return CircularProgressIndicator();
//     } else if (allcathotel!.isEmpty) {
//       return Text("No data available");
//     } else {
//       return ListView.builder(
//         itemCount: allcathotel!.length,
//         itemBuilder: (context, index) {
//           final cathotel = allcathotel![index];
//           return ListTile(
//             title: Text(cathotel.user!.username),
//             subtitle: Text("Average Rating: '$calculateAverageRating()'"),
//           );
//         },
//       );
//     }
//   }
// }
