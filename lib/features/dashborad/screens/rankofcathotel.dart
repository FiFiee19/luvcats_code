// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
// import 'package:luvcats_app/models/cathotel.dart';
// import 'package:luvcats_app/models/review.dart';
// import 'package:luvcats_app/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// class DashboardRank extends StatefulWidget {
//   const DashboardRank({super.key});

//   @override
//   State<DashboardRank> createState() => _DashboardRankState();
// }

// class _DashboardRankState extends State<DashboardRank> {
//   List<Cathotel>? allCathotels;
//   List<Review>? reviews;
//   int? rank; // The rank of your specific cathotel
//   int? totalCathotels;
//   Cathotel? highestRatedCathotel;
//   final CathotelServices cathotelServices = CathotelServices();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchAllCathotels();
//     });
//   }

//   Future<void> fetchAllCathotels() async {
//     // Correctly fetching all cathotels and sorting them
//     List<Cathotel> cathotels = await cathotelServices.fetchAllCathotel();
//     if (cathotels.isNotEmpty) {
//       cathotels.sort((a, b) => b.averageRating.compareTo(a.averageRating));

//       // Assuming you're interested in finding the rank of the user's own cathotel
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       reviews =
//             cathotelServices.fetchReviewsUser(context, userProvider.user.id);
//       String yourCathotelId = reviews; // Assuming this is how you get the user's cathotel ID

//       setState(() {
//         allCathotels = cathotels;
//         highestRatedCathotel = cathotels.first;
//         totalCathotels = cathotels.length;
//         rank = cathotels.indexWhere((c) => c.id == yourCathotelId) + 1; // Finding the rank
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cathotel Rankings'),
//       ),
//       body: buildBody(),
//     );
//   }

//   Widget buildBody() {
//     if (allCathotels == null) {
//       return Center(child: CircularProgressIndicator());
//     } else if (allCathotels!.isEmpty) {
//       return Center(child: Text("No cathotels available"));
//     } else {
//       return ListView(
//         children: [
//           if (highestRatedCathotel != null)
//             ListTile(
//               title: Text('Highest Rated Cathotel: ${highestRatedCathotel!.name}'),
//               subtitle: Text('Rating: ${highestRatedCathotel!.averageRating.toStringAsFixed(2)}'),
//             ),
//           if (rank != null && totalCathotels != null)
//             ListTile(
//               title: Text('Your Cathotel Rank: $rank out of $totalCathotels'),
//             ),
//         ],
//       );
//     }
//   }
// }
