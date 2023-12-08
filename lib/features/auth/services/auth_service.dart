import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String images,
    required String description,
  }) async {
    try {
      User user = User(
        id: '',
        username: username,
        password: password,
        email: email,
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('${url}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        //succes signup
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account has been successfully created'),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
        Navigator.of(context).pop();
      }
      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account with this email already exists'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      if (res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter a valid email address'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${url}/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // if (res.statusCode == 200) {
      //   //succes signin
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: const Text('Account has been successfully login'),
      //       backgroundColor: Colors.grey,
      //       behavior: SnackBarBehavior.floating,
      //       margin: EdgeInsets.all(30),
      //     ),
      //   );
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   // userProvider.setUser(res.body);
      //   Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      //   await prefs.setString('authtoken', jsonDecode(res.body)['token']);
      //   navigator.pushAndRemoveUntil(
      //     CupertinoPageRoute(
      //       builder: (context) => const Home(),
      //     ),
      //     (route) => false,
      //   );
      // }
      // if (res.statusCode == 400) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('User with this email does not exists'),
      //       backgroundColor: Colors.red,
      //       behavior: SnackBarBehavior.floating,
      //       margin: EdgeInsets.all(30),
      //     ),
      //   );
      // }
      // if (res.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Incorrect password'),
      //       backgroundColor: Colors.red,
      //       behavior: SnackBarBehavior.floating,
      //       margin: EdgeInsets.all(30),
      //     ),
      //   );
      // }
      // if (res.statusCode == 500) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(res.body.toString()),
      //       backgroundColor: Colors.red,
      //       behavior: SnackBarBehavior.floating,
      //       margin: EdgeInsets.all(30),
      //     ),
      //   );
      // }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('authtoken', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
            (route) => false,
          );
        },
      );

      print(res.statusCode);
      print(res.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authtoken');

      if (token == null) {
        prefs.setString('authtoken', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${url}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${url}/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authtoken': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authtoken', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SigninScreen(),
      ),
      (route) => false,
    );
  }
}
