// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/profile/services/profile_service.dart';
// import 'package:luvcats_app/models/user.dart';

// class SearchProfile extends StatefulWidget {

//   const SearchProfile({Key? key}) : super(key: key);

//   @override
//   State<SearchProfile> createState() => _SearchProfileState();
// }

// class _SearchProfileState extends State<SearchProfile> {
//   List<User> searchResults = [];
//   ProfileServices profileService = ProfileServices();
//   final searchController = TextEditingController();

//   Future<void> search() async {
//     final results =
//         await profileService.searchName(context, searchController.text);
//     // Assuming that searchName returns a List<User>
//     if (results != null) {
//       setState(() {
//         searchResults = results;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//           IconButton(
//             onPressed: () {
//               showSearch(
//                   context: context,
//                   delegate: CustomSearchDelegate(),);
//             },
//             icon: const Icon(Icons.search),
//           );

//   }
// }

// class CustomSearchDelegate extends SearchDelegate {
//   List<User> searchResults = [];

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
//     List<String> matchQuery = [];
//     for (var user in searchResults) {
//       if (user.username.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(user.username);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var user in searchResults) {
//       if (user.username.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(user.username);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/features/profile/screens/profilescreen.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/profileofuser/screens/profileofuser.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SearchProfile extends StatelessWidget {
  const SearchProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // สร้างปุ่มที่เมื่อกดจะเปิด CustomSearchDelegate
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        // เรียกใช้งาน showSearch พร้อม CustomSearchDelegate
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<User?> {
  final ProfileServices profileService = ProfileServices();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // เรียกใช้งานการค้นหาและแสดงผลลัพธ์
    return FutureBuilder<List<User>?>(
      future: profileService.searchName(context, query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        }
        final searchResults = snapshot.data!;
        return ListView(
          children: searchResults
              .map((user) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      user.imagesP,
                    ),
                    radius: 20,
                  ),
                  title: Text(user.username),
                  // สมมติว่าคุณมีการคลิกที่ชื่อผู้ใช้จากผลการค้นหา
                  onTap: () {
                    final currentUser =
                        Provider.of<UserProvider>(context, listen: false).user;
                    if (user.id == currentUser.id) {
                      // หากชื่อที่คลิกตรงกับชื่อผู้ใช้ที่เข้าสู่ระบบ นำทางไปยังหน้าโปรไฟล์ของตัวเอง
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            ProfileScreen(),
                                ),
                      );
                    } else {
                      // หากไม่ใช่ นำทางไปยังหน้าโปรไฟล์ของผู้ใช้อื่น
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileOfUser(user: user)),
                      );
                    }
                  }


                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Container();
  }
}
