import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(Duration(seconds: 2)); 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('authtoken');

    if (userToken == null || userToken.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SigninScreen()));
    } else {
     
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:luvcats_app/models/user.dart';

// class Splashscreen extends StatefulWidget {
//   final token;

//   const Splashscreen({
//     Key? key,
//     required this.token,
//   }) : super(key: key);

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   late String email;

//   @override
//   void initState() {
//     super.initState();
//     Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
//     email = jwtDecodedToken["email"];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text(email),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:luvcats_app/features/auth/screens/signin.dart';
// // import 'package:luvcats_app/features/home/home.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class SplashScreen extends StatefulWidget {
// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkLoginStatus();
// //   }

// //   void _checkLoginStatus() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final token = prefs.getString('authtoken') ?? '';
// //     if (token.isNotEmpty) {
// //       // Validate the token with your backend or assume it's valid
// //       Navigator.of(context)
// //           .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
// //     } else {
// //       Navigator.of(context).pushReplacement(
// //           MaterialPageRoute(builder: (context) => SigninScreen()));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: CircularProgressIndicator(),
// //       ),
// //     );
// //   }
// // }
