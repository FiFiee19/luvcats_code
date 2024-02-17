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
        },body: jsonEncode({
          'commuId': commuId,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Post deleted successfully.");
          // คุณอาจต้องการอัปเดต UI ที่นี่
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteCatStrayCat(BuildContext context, String straycatId) async {
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

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Post deleted successfully.");

        },
      );
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
          SnackBar(content: Text('Password updated successfully')),
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
        showSnackBar(context, 'Profile updated successfully!');
        Navigator.pop(context);

        // Assuming you have a function to parse the updated user data from the response
        User updatedUser = User.fromJson(json.decode(response.body));
        return updatedUser; // Return the updated user
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
    return null; // Return null if the update was not successful
  }
}
