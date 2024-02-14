import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CommuServices {
  void postcommu({
    required BuildContext context,
    required String user_id,
    required String title,
    required String description,
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

      Commu commu = Commu(
        user_id: user_id,
        title: title,
        description: description,
        likes: [],
        comments: [],
        images: imageUrls,
      );

      http.Response res = await http.post(
        Uri.parse('$url/postCommu'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: commu.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Post Added Successfully!');
          Navigator.pop(context);
        },
      );
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

  Future<List<Commu>> fetchAllCommu(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Commu> commuList = [];
    try {
      http.Response res = await http.get(Uri.parse('$url/getCommu'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            commuList.add(
              Commu.fromJson(
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
    return commuList;
  }

  Future<void> likesCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res =
          await http.put(Uri.parse('$url/likesCommu/$commuId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Commu> fetchIdCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getCommu/$commuId'),
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
            return Commu.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
          // ถ้าข้อมูลที่ได้รับเป็น Map แสดงว่าเป็น single object
          return Commu.fromMap(data);
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

  Future<List<Comment>> fetchComment(
      BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getComment/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );
      
      if (res.statusCode == 200) {
        List<dynamic> commentsData = jsonDecode(res.body);
        print(commentsData);
        return commentsData.map((data) {
          return Comment.fromMap(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<void> addComment({
    required BuildContext context,
    required String user_id,
    required String message,
    required String commuId, // ถ้า post_id เป็นค่าที่จำเป็น ควรลบ ? ออก
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$url/addComment/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'user_id': user_id,
          'message': message,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add Comment Success')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> editPost(
    BuildContext context,
    String commuId,
    String title,
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
        Uri.parse('$url/getCommu/edit/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'images': imageUrls, // ส่ง URL ของรูปภาพใหม่ไปด้วย
        }),
      );

      if (res.statusCode == 200) {
        showSnackBar(context, 'Post updated successfully!');
          Navigator.pop(context);
      } else {
        print('Failed to update post: ${res.body}');
      }
    } catch (e) {
      print('Error updating post: $e');
    }
  }
}
