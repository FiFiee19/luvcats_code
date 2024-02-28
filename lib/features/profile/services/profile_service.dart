import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileServices {
  Future<List<Commu>> fetchCommuProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user.id;
    List<Commu> commuList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getCommu/$user'), headers: {
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

  Future<List<Commu>> fetchCommuId(BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<Commu> commuList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getCommu/id/$user_id'), headers: {
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

  Future<List<Straycat>> fetchStrayCatProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user.id;
    List<Straycat> straycatList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat/$user'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            straycatList.add(
              Straycat.fromJson(
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
    return straycatList;
  }

  Future<List<Straycat>> fetchStrayCatId(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<Straycat> straycatList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat/id/$user_id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            straycatList.add(
              Straycat.fromJson(
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
    return straycatList;
  }

  Future<User> fetchIdUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    try {
      http.Response res = await http.get(
        Uri.parse('$url/profile/$user_id'),
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
            return User.fromMap(firstPost);
          } else {
            throw Exception('Data format is not correct');
          }
        } else if (data is Map<String, dynamic>) {
          // ถ้าข้อมูลที่ได้รับเป็น Map แสดงว่าเป็น single object
          return User.fromMap(data);
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

  Future<void> deleteCatCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getCommu/delete/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'commuId': commuId,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
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
        // กรณีอีเมลไม่ถูกต้อง แสดง SnackBar แจ้งให้ผู้ใช้ทราบ
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

  Future<void> deleteCatStrayCat(
      BuildContext context, String straycatId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getStrayCat/delete/$straycatId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'straycatId': straycatId,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
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
        // กรณีอีเมลไม่ถูกต้อง แสดง SnackBar แจ้งให้ผู้ใช้ทราบ
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
      showSnackBar(context, e.toString());
    }
  }

  Future<void> editPassword(
    BuildContext context,
    String password,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    // อัปโหลดรูปภาพใหม่และรับ URL
    try {
      final res = await http.put(
        Uri.parse('$url/editP/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'password': password,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('แก้ไขรหัสผ่านสำเร็จ!')),
        );
        Navigator.pop(context);
        print(res.body);
      } else {
        print('Failed to update password: ${res.body}');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  Future<User?> editUser(
      BuildContext context, String username, File? image) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    String? imageUrl = userProvider.user.imagesP;

    try {
      if (image != null) {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: 'a'),
        );
        imageUrl = response.secureUrl;
      }

      final response = await http.put(
        Uri.parse('$url/editU/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'username': username,
          'imagesP': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'แก้ไขสำเร็จ!');
        Navigator.pop(context);

        User updatedUser = User.fromJson(json.decode(response.body));
        return updatedUser;
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
    return null;
  }

  Future<List<User>?> searchName(BuildContext context, String username) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$url/searchU/$username'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        final List<User> users =
            dataList.map((data) => User.fromMap(data)).toList();
        return users;
      } else {
        print(
            'Failed to search for users. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while searching for users: $e');
      return null;
    }
  }

  Future<List<User>?> searchEntre(BuildContext context, String username) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$url/searchE/$username'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        final List<User> users =
            dataList.map((data) => User.fromMap(data)).toList();
        return users;
      } else {
        print(
            'Failed to search for users. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while searching for users: $e');
      return null;
    }
  }
}
