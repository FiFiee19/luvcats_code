import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/poststraycat.dart';
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

  Future<void> deleteCatCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getCommu/delete/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
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

  Future<void> deleteCatStrayCat(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getStrayCat/delete/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
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

  Future<void> editPassword(
    BuildContext context,
    String password,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    // อัปโหลดรูปภาพใหม่และรับ URL
    try {
      final res = await http.put(
        Uri.parse('$url/editU/$user_id'),
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
      } else {
        print('Failed to update password: ${res.body}');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  Future<void> editUser(
    BuildContext context,
    String password,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    // อัปโหลดรูปภาพใหม่และรับ URL
    try {
      final res = await http.put(
        Uri.parse('$url/editU/$user_id'),
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
      } else {
        print('Failed to update password: ${res.body}');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }
}
