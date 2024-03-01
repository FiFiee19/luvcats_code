import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EntreService {
  //ลงทะเบียนเป็นผู้ประกอบการ
  void signinEntre({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String imagesP,
    required String user_id,
    required String store_id,
    required String name,
    required String phone,
    required String store_address,
    required String description,
    required double price,
    required String contact,
    required String province,
    required List<String> images,
  }) async {
    final navigator = Navigator.of(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Map<String, dynamic> requestData = {
        'username': username,
        'password': password,
        'email': email,
        'imagesP': imagesP,
        'user_id': userProvider.user.id,
        'store_id': store_id,
        'name': name,
        'store_address': store_address,
        'phone': phone,
        'description': description,
        'price': price,
        'contact': contact,
        'province': province,
        'images': images,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.body.toString())),
        );
      }

      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      if (res.statusCode == 500) {
        // กรณีอีเมลไม่ถูกต้อง
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
  
  //แก้ไขข้อมูลcathotel
  Future<void> editProfileEntre(
    BuildContext context,
    String cathotelId,
    double price,
    String contact,
    String province,
    String description,
    List<File> images, // รูปภาพใหม่เป็น File
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> imageUrls = [];
    // อัปโหลดรูปภาพใหม่และรับ URL
    if (images != null && images.isNotEmpty) {
      // อัปโหลดรูปภาพใหม่และรับ URL
      try {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: 'a'),
          );
          imageUrls.add(res.secureUrl);
        }
      } catch (e) {
        print('Error uploading images: $e');
      }
    } else {
      final post = await fetchIdCathotel(context, userProvider.user.id);
      imageUrls = post.images;
    }

    final requestBody = jsonEncode({
      'price': price,
      'contact': contact,
      'province': province,
      'description': description,
      'images': imageUrls,
    });
    print(requestBody);
    try {
      final res = await http.put(Uri.parse('$url/getCathotel/edit/$cathotelId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'authtoken': userProvider.user.token,
          },
          body: requestBody);
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สำเร็จ!')),
        );
        Navigator.pop(context);
      }

      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
      if (res.statusCode == 500) {
        // กรณีอีเมลไม่ถูกต้อง
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.body.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
    } catch (e) {
      print('Error updating post: $e');
    }
  }
  
  //ดึงข้อมูลcathotelจากuser_idที่กำหนด
  Future<Cathotel> fetchIdCathotel(BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getCathotel/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data is List) {
          final firstPost = data.first;
          if (firstPost is Map<String, dynamic>) {
            return Cathotel.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
          return Cathotel.fromMap(data);
        } else {
          throw Exception('Data format is not correct');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
  
  //แก้ไขข้อมูลส่วนตัว
  Future<void> editEntre(
    BuildContext context,
    String entreId,
    String name,
    String store_address,
    String phone,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.put(
        Uri.parse('$url/getEntre/edit/$entreId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'name': name,
          'store_address': store_address,
          'phone': phone,
        }),
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สำเร็จ!')),
        );
        Navigator.pop(context);
      }

      
    } catch (e) {
      print('Error updating post: $e');
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

  //ดึงข้อมูลผู้ประกอบการจากuser_id
  Future<Entrepreneur> fetchIdEntre(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getEntre/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data is List) {
          final firstPost = data.first;
          if (firstPost is Map<String, dynamic>) {
            return Entrepreneur.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
          return Entrepreneur.fromMap(data);
        } else {
          throw Exception('Data format is not correct');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
