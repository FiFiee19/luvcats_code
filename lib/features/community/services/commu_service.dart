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
import 'package:luvcats_app/models/report.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CommuServices {
  //โพสต์community
  void postcommu({
    required BuildContext context,
    required String user_id,
    required String title,
    required String description,
    required List<String> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Commu commu = Commu(
        user_id: user_id,
        title: title,
        description: description,
        likes: [],
        comments: [],
        images: [],
      );

      http.Response res = await http.post(
        Uri.parse('$url/postCommu'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: commu.toJson(),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('โพสต์สำเร็จ!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('เกิข้อผิดพลาด');
      }
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

  //ดึงข้อมูลcommuทั้งหมด
  Future<List<Commu>> fetchAllCommu(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Commu> commuList = [];
    try {
      http.Response res = await http.get(Uri.parse('$url/getCommu'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });
      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          commuList.add(
            Commu.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            ),
          );
        }
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
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
    return commuList;
  }

  //กดไลค์commu
  Future<void> likesCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res =
          await http.put(Uri.parse('$url/likesCommu/$commuId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {}
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

  //ดึงข้อมูลcommuจากidของcommuที่กำหนด
  Future<Commu> fetchIdCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getCommu/commu/$commuId'),
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
            return Commu.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
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

  //ดึงข้อมูลคอมเมนต์ของcommuจากidที่กำหนด
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
        throw Exception('เกิดข้อผิดพลาด');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  //คอมเมนต์
  Future<void> addComment({
    required BuildContext context,
    required String user_id,
    required String message,
    required String commu_id, // ถ้า post_id เป็นค่าที่จำเป็น ควรลบ ? ออก
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$url/addComment/$commu_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode(
            {'user_id': user_id, 'message': message, 'commu_id': commu_id}),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คอมเมนต์สำเร็จ!')),
        );
      } else {
        throw Exception('Failed to add comment');
      }
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

  //ลบคอมเมนต์
  Future<void> deleteComment(BuildContext context, String commentId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getComment/delete/$commentId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {}
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

  //แก้ไขโพสต์
  Future<void> editPost(
    BuildContext context,
    String commuId,
    String title,
    String description,
    List<File> images, // รูปภาพใหม่เป็น File
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> imageUrls = [];
    if (images != null && images.isNotEmpty) {
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
      // ถ้าไม่มีการเลือกรูปภาพใหม่ใช้รูปภาพเดิมที่เก็บไว้ในฐานข้อมูล
      final post = await fetchIdCommu(context, commuId);
      imageUrls = post.images;
    }

    // ส่งข้อมูลโพสต์ร่วมกับ URL รูปภาพ
    try {
      final res = await http.put(
        Uri.parse('$url/getStrayCat/edit/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'images': imageUrls,
        }),
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('แก้ไขสำเร็จ!')),
        );
        Navigator.pop(context);
      }
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

  //รายงานปัญหา
  Future<void> report({
    required BuildContext context,
    required String user_id,
    required String message,
    required String commu_id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$url/postReport/$commu_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode(
            {'user_id': user_id, 'message': message, 'commu_id': commu_id}),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รายงานสำเร็จ!')),
        );
        Navigator.pop(context);
      } else {
        print(res.body);
        throw Exception('รายงานไม่สำเร็จ!');
      }
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

  //ดึงข้อมูลreportของcommuจากidที่กำหนด
  Future<List<Report>> fetchReport(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getReport/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> reportData = jsonDecode(res.body);
        print(reportData);
        return reportData.map((data) {
          return Report.fromMap(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('โหลดข้อมูลรายงานไม่สำเร็จ');
      }
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }

  Future<List<Report>> fetchAllReport(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Report> commuList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$url/getReport'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      // print('Response Body: ${res.body}'); // Print the response body

      if (res.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(res.body);
        for (int i = 0; i < jsonData.length; i++) {
          commuList.add(
            Report.fromJson(jsonData[i]),
          );
        }

        // Print the commuList to check if it's populated correctly
        print('Commulist: $commuList');

        commuList.forEach((report) {
          print('Report ID: ${report.id}');
          print('User ID: ${report.user_id}');
          print('Message: ${report.message}');
          print('Commu: ${report.commu_id}');
          // Print other relevant fields as needed
        });
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
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
    return commuList;
  }
}
