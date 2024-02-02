import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EntreService {
  void cathotel({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String imagesP,
    required String user_id,
    required String store_id,
    required String name,
    required String phone,
    required String user_address,
    required String store_address,
    required String description,
    required String price,
    required String contact,
    required String province,
    required List<File> images,
  }) async {
    final navigator = Navigator.of(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: user_id),
        );
        imageUrls.add(res.secureUrl);
      }

      Map<String, dynamic> requestData = {
        'username': username,
        'password': password,
        'email': email,
        'imagesP': imagesP,
        'user_id': userProvider.user.id,
        'store_id':store_id,
        'name': name,
        'user_address': user_address,
        'store_address': store_address,
        'phone': phone,
        'description': description,
        'price': price,
        'contact': contact,
        'province': province,
        'images': imageUrls,
      };
      http.Response res = await http.post(
        Uri.parse('${url}/signup_entre'),
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
        // กรณีลงทะเบียนสำเร็จแสดง SnackBar แจ้งให้ผู้ใช้ทราบ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account has been successfully created'),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
        
      }

      if (res.statusCode == 400) {
        // กรณีมีบัญชีผู้ใช้ด้วยอีเมลที่ซ้ำกันแสดง SnackBar แจ้งให้ผู้ใช้ทราบ
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
        // กรณีอีเมลไม่ถูกต้อง แสดง SnackBar แจ้งให้ผู้ใช้ทราบ
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
}

Future<List<Entrepreneur>> fetchAllEntre(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  List<Entrepreneur> entreList = [];
  try {
    http.Response res = await http.get(Uri.parse('$url/getEntre'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'authtoken': userProvider.user.token,
    });

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        res.body;
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return entreList;
}
