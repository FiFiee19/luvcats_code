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

  Future<void> likesCommu(BuildContext context, String post_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res =
          await http.put(Uri.parse('$url/likesCommu/$post_id'), headers: {
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

  Future<void> addComment(
      BuildContext context, String post_id, String message) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Comment comment =
          Comment(message: message, user_id: userProvider.user.id);
      http.Response res = await http.post(Uri.parse('$url/addComment/$post_id'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'authtoken': userProvider.user.token,
          },
          body: comment.toJson());

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Your success handling code here
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Comment>> fetchComment(
      BuildContext context, String post_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getComment/$post_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> commentsData = jsonDecode(res.body);
        print(commentsData);
        return commentsData.map((data) {
          // แปลง data เป็น Map<String, dynamic> และส่งไปยัง Comment.fromMap
          return Comment.fromMap(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }
}
