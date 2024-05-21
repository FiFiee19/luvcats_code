import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/report.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
        images: images,
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
      await http.put(
        Uri.parse('$url/likesCommu/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );
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
        return Commu.fromMap(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // //ดึงข้อมูลcommuจากidของcommuที่กำหนด
  // Future<Commu> fetchUserIdCommu(BuildContext context, String userId) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   try {
  //     http.Response res = await http.get(
  //       Uri.parse('$url/getCommu/id/$userId'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'authtoken': userProvider.user.token,
  //       },
  //     );

  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);

  //       if (data is List) {
  //         final firstPost = data.first;
  //         if (firstPost is Map<String, dynamic>) {
  //           return Commu.fromMap(firstPost);
  //         } else {
  //           throw Exception('Data format is not correct');
  //         }
  //       } else if (data is Map<String, dynamic>) {
  //         return Commu.fromMap(data);
  //       } else {
  //         throw Exception('Data format is not correct');
  //       }
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching data: $e');
  //   }
  // }

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

  Future<List<Comment>> noti_Comment(
      BuildContext context, String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getComment/id/$userId'),
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
    required String commu_id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Comment comment =
        Comment(user_id: user_id, message: message, commu_id: commu_id);
    try {
      final res = await http.post(
        Uri.parse('$url/addComment/$commu_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: comment.toJson(),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คอมเมนต์สำเร็จ!')),
        );
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

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
        );
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

  //แก้ไขโพสต์
  Future<void> editPostCommu(
    BuildContext context,
    String commuId,
    String title,
    String description,
    List<File> images,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    List<String> imageUrls = [];
    var uuid = Uuid();
    String folderPath = "Commu/${user_id}/edit/${uuid.v4()}";
    if (images != null && images.isNotEmpty) {
      try {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: folderPath, publicId: "รูปที่${i + 1}"),
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
        Uri.parse('$url/getCommu/edit/$commuId'),
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

  // //ดึงข้อมูลreportของcommuจากidที่กำหนด
  // Future<List<Report>> fetchReport(BuildContext context, String commuId) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   try {
  //     http.Response res = await http.get(
  //       Uri.parse('$url/getReport/$commuId'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'authtoken': userProvider.user.token,
  //       },
  //     );

  //     if (res.statusCode == 200) {
  //       List<dynamic> reportData = jsonDecode(res.body);
  //       print(reportData);
  //       return reportData.map((data) {
  //         return Report.fromMap(data as Map<String, dynamic>);
  //       }).toList();
  //     } else {
  //       throw Exception('โหลดข้อมูลรายงานไม่สำเร็จ');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching reports: $e');
  //   }
  // }

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

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          print(res.body);
          commuList.add(
            Report.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            ),
          );
        }
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

  //ลบคอมเมนต์
  Future<void> deleteReport(BuildContext context, String reportId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getReport/delete/$reportId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
        );
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

  // Future<List<Commu>> fetchLikes(BuildContext context, String userId) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   List<Commu> commuLikes = [];
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$url/getCommu/$userId/likes'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'authtoken': userProvider.user.token,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       List<dynamic> body = jsonDecode(response.body);
  //       commuLikes = body
  //           .map((dynamic item) => Commu.fromJson(jsonEncode(item)))
  //           .toList();
  //     } else {
  //       throw Exception('Failed to load likes');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //         margin: EdgeInsets.all(30),
  //       ),
  //     );
  //   }
  //   return commuLikes;
  // }
}
