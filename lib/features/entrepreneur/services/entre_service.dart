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
    required String store_address,
    required String description,
    required double price,
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
        'store_id': store_id,
        'name': name,
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

    // อัปโหลดรูปภาพใหม่และรับ URL
    try {
      final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: 'a'),
        );
        imageUrls.add(res.secureUrl);
      }

      final res = await http.put(
        Uri.parse('$url/getStrayCat/edit/$cathotelId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'price': price,
          'contact': contact,
          'province': province,
          'description': description,
          'images': imageUrls, // ส่ง URL ของรูปภาพใหม่ไปด้วย
        }),
      );
       httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Profile updated successfully!');
          Navigator.pop(context);
        },
      );
      
    } catch (e) {
      print('Error updating post: $e');
    }
  }

Future<Cathotel> fetchIdCathotel(BuildContext context, String cathotelId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getCathotel/edit/$cathotelId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // ตรวจสอบว่าข้อมูลที่ได้รับเป็น List หรือ Map
        if (data is List) {
          // สมมติว่า API ส่งกลับมาเป็น array และคุณต้องการ object แรก
          final firstPost = data.first;
          if (firstPost is Map<String, dynamic>) {
            return Cathotel.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
          // ถ้าข้อมูลที่ได้รับเป็น Map แสดงว่าเป็น single object
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

Future<Entrepreneur?> fetchIdProfile(BuildContext context, String user_id) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  Entrepreneur? catprofile;

  try {
    final http.Response res = await http.get(
      Uri.parse('$url/getEntre/$user_id'), // Ensure $url is correctly defined
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      if (body.isNotEmpty) {
        // Assuming you want the first Cathotel object from the list
        catprofile = Entrepreneur.fromMap(body.first);
      } else {
        showSnackBar(context, 'No Cathotel data found for the user.');
      }
    } else {
      showSnackBar(context, 'Error: ${res.statusCode}');
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }

  return catprofile;
}


Future<List<Entrepreneur>> fetchEntreIdProfile(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user.id;
  List<Entrepreneur> entreIdList = [];
  try {
    http.Response res =
        await http.get(Uri.parse('$url/getEntre/$user'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'authtoken': userProvider.user.token,
    });

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          entreIdList.add(
            Entrepreneur.fromJson(
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
  return entreIdList;
}
}