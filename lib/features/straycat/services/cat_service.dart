import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CatServices {
  void postcat({
    required BuildContext context,
    required User user,
    required String user_id,
    required String breed,
    required String description,
    required String gender,
    required String province,
    required List<File> images,
  }) async {
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
      
      Cat cat = Cat(
        user_id: user_id,
        breed: breed,
        gender: gender,
        province: province,
        description: description,
        images: imageUrls,
        
      );

      http.Response res = await http.post(
        Uri.parse('$url/postStrayCat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: cat.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
      // if (res.statusCode == 200) {
      //   // กรณีลงทะเบียนสำเร็จแสดง SnackBar แจ้งให้ผู้ใช้ทราบ
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: const Text('Product Added Successfully!'),
      //       backgroundColor: Colors.grey,
      //       behavior: SnackBarBehavior.floating,
      //       margin: EdgeInsets.all(30),
      //     ),
      //   );
      //   Navigator.of(context).pop();
      // }
    } catch (e) {
      // showSnackBar(context, e.toString());
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

  Future<List<Cat>> fetchAllCats(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Cat> catList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            catList.add(
              Cat.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return catList;
  }
}
