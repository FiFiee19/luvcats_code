import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/features/admin/screens/adminscreen.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/entrepreneur/screens/entrescreen.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //สมัครสมาชิก
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String imagesP,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        'username': username,
        'password': password,
        'email': email,
        'imagesP': imagesP,
      };
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${url}/api/signup'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        navigator.pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const SigninScreen(),
          ),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลงทะเบียนสำเร็จ!')),
        );
      }

      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(30),
          ),
        );
      }

      if (res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(30),
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
          margin: const EdgeInsets.all(30),
        ),
      );
    }
  }

  //เข้าสู่ระบบ
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
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser(res.body);
        final userData = jsonDecode(res.body);
        await prefs.setString('authtoken', userData['token']);
        navigator.pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const SigninScreen(),
          ),
          (route) => false,
        );

        if (userData['user']['type'] == 'admin') {
          navigator.pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const HomeScreenAdmin(),
            ),
            (route) => false,
          );
        } else if (userData['user']['type'] == 'entrepreneur') {
          navigator.pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const HomeScreenEntre(),
            ),
            (route) => false,
          );
        } else {
          navigator.pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const Home(),
            ),
            (route) => false,
          );
        }
      }

      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(30),
          ),
        );
      }

      if (res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(30),
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
          margin: const EdgeInsets.all(30),
        ),
      );
    }
  }

  //ออกจากระบบ
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
