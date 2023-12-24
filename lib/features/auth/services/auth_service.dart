import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/admin/screens/home_admin.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/alert_type.dart';
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
      Map<String, dynamic> requestData = {
        'username': username,
        'password': password,
        'email': email,
        'images': images,
        'description': description,
      };
      // ส่งคำขอ HTTP POST เพื่อสร้างบัญชีผู้ใช้ใหม่
      http.Response res = await http.post(
        Uri.parse('${url}/api/signup'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return const AlertType();
          },
        );
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
        // if (!RegExp(
        //         r'^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i')
        //     .hasMatch(email)) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('กรุณากรอกที่อยู่อีเมลที่ถูกต้อง'),
        //       backgroundColor: Colors.red,
        //       behavior: SnackBarBehavior.floating,
        //       margin: EdgeInsets.all(30),
        //     ),
        //   );
        // }

        // if (!RegExp(r'^(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$').hasMatch(password)) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('รหัสผ่านควรมีอักขระ 8 ตัวขึ้นไป'),
        //       backgroundColor: Colors.red,
        //       behavior: SnackBarBehavior.floating,
        //       margin: EdgeInsets.all(30),
        //     ),
        //   );
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      print(res.statusCode);
      print(res.body);
      print(username);
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
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account has been successfully login'),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser(res.body);
        await prefs.setString('authtoken', jsonDecode(res.body)['token']);

        final userData = jsonDecode(res.body);
        if (userData['user']['type'] == 'admin') {
          navigator.pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const AdminScreen(),
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
            content: Text('User with this email does not exists'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      if (res.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect password'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      if (res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
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

  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
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

        userProvider.setUser(userRes.body);
        print(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
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
