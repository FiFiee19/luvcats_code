// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:luvcats_app/config/constants.dart';
// import 'package:luvcats_app/models/profile.dart';
// import 'package:luvcats_app/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// class ProfileServices {
//   Future<Profile> fetchProfile(BuildContext context) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     try {
//       final res = await http.post(
//         Uri.parse('$url/profile/userId'), // ใช้ user ID ที่นี่
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'authtoken': userProvider.user.token,
//         },
//       );

//       if (res.statusCode == 200) {
//         return Profile.fromJson(json.decode(res.body));
//       } else {
//         throw Exception('Failed to load profile');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }
