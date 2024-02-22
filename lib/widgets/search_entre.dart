// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/cathotel/screens/detail_cathotel.dart';
// import 'package:luvcats_app/features/home/home.dart';
// import 'package:luvcats_app/features/profile/screens/profilescreen.dart';
// import 'package:luvcats_app/features/profile/services/profile_service.dart';
// import 'package:luvcats_app/features/profileofuser/screens/profileofuser.dart';
// import 'package:luvcats_app/models/user.dart';
// import 'package:luvcats_app/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// class CustomSearchDelegate extends SearchDelegate<User?> {
//   final List<User> currentuser; // สมมติว่าคุณมีรายการ straycats

//   CustomSearchDelegate(this.currentuser);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = currentuser.where((name) {
//       return name.username.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final result = results[index];
//         return ListTile(
//           title: Text(result.username),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailStraycatScreen(straycat: result),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // โค้ดสำหรับ build suggestions สามารถเขียนได้คล้ายกับ buildResults
//     return Container();
//   }
// }

// // class SearchEntre extends StatelessWidget {
// //   const SearchEntre({super.key});

// //   @override
// //   Widget build(BuildContext context) {
    
// //     return IconButton(
// //       icon: const Icon(Icons.search),
// //       onPressed: () {
       
// //         showSearch(
// //           context: context,
// //           delegate: CustomSearchDelegate(),
// //         );
// //       },
// //     );
// //   }
// // }

// // class CustomSearchDelegate extends SearchDelegate<User?> {
// //   final ProfileServices profileService = ProfileServices();

// //   @override
// //   List<Widget> buildActions(BuildContext context) {
// //     return [
// //       if (query.isNotEmpty)
// //         IconButton(
// //           icon: const Icon(Icons.clear),
// //           onPressed: () {
// //             query = '';
// //           },
// //         ),
// //     ];
// //   }

// //   @override
// //   Widget buildLeading(BuildContext context) {
// //     return IconButton(
// //       icon: const Icon(Icons.arrow_back),
// //       onPressed: () {
// //         close(context, null);
// //       },
// //     );
// //   }

// //   @override
// //   Widget buildResults(BuildContext context) {
// //     // เรียกใช้งานการค้นหาและแสดงผลลัพธ์
// //     return FutureBuilder<List<User>?>(
// //       future: profileService.searchEntre(context, query),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         if (snapshot.hasError) {
// //           return Center(child: Text('Error: ${snapshot.error}'));
// //         }
// //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //           return const Center(child: Text('No results found.'));
// //         }
// //         final searchResults = snapshot.data!;
// //         return ListView(
// //           children: searchResults
// //               .map((user) => ListTile(
// //                   leading: CircleAvatar(
// //                     backgroundColor: Colors.grey,
// //                     backgroundImage: NetworkImage(
// //                       user.imagesP,
// //                     ),
// //                     radius: 20,
// //                   ),
// //                   title: Text(user.username),
// //                   // สมมติว่าคุณมีการคลิกที่ชื่อผู้ใช้จากผลการค้นหา
// //                   onTap: () {
// //                     final currentUser =
// //                         Provider.of<UserProvider>(context, listen: false).user;
// //                     if (user.id == currentUser.id) {
// //                       // หากชื่อที่คลิกตรงกับชื่อผู้ใช้ที่เข้าสู่ระบบ นำทางไปยังหน้าโปรไฟล์ของตัวเอง
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                             const DetailCathotelScreen(cathotel: ),
// //                                 ),
// //                       );
// //                     } else {
// //                       // หากไม่ใช่ นำทางไปยังหน้าโปรไฟล์ของผู้ใช้อื่น
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                                 ProfileOfUser(user: user)),
// //                       );
// //                     }
// //                   }


// //                   ))
// //               .toList(),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget buildSuggestions(BuildContext context) {

// //     return Container();
// //   }
// // }
