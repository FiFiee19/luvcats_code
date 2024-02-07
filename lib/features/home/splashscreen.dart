// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/auth/screens/signin.dart';
// import 'package:luvcats_app/features/home/home.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       await checkLoginStatus();
//     });
//   }

//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authtoken');
//     print("Token from SharedPreferences: $token");

//     if (token != null && token.isNotEmpty) {
//       // Token มีอยู่, นำทางไปยังหน้าหลัก
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => const Home()));
//     } else {
//       // ไม่พบ token, นำทางไปยังหน้าล็อกอิน
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const SigninScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
