import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/review.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CathotelServices {
  //ดึงข้อมูลcathotelทั้งหมด
  Future<List<Cathotel>> fetchAllCathotel(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Cathotel> cathotelList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getCathotel'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          cathotelList.add(
            Cathotel.fromJson(
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
    return cathotelList;
  }
  
  //ดึงข้อมูลโปรไฟล์ของCathotelที่มี user_id ที่กำหนด
  Future<Cathotel?> fetchCatIdProfile(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Cathotel? catprofile;

    try {
      final http.Response res = await http.get(
        Uri.parse('$url/getCathotel/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        if (body.isNotEmpty) {
          catprofile = Cathotel.fromMap(body.first);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${res.statusCode}'),
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

    return catprofile;
  }
  
  //ดึงข้อมูลรีวิวร้านฝากเลี้ยงตามidของร้านที่กำหนด
  Future<List<Review>> fetchReviews(
      BuildContext context, String cathotelId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getReview/$cathotelId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> commentsData = jsonDecode(res.body);
        print(commentsData);
        return commentsData.map((data) {
          return Review.fromMap(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }
  
  //ดึงข้อมูลรีวิวของร้านฝากเลี้ยงตามuser_idที่กำหนด
  Future<List<Review>> fetchReviewsUser(
      BuildContext context, String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getReviewU/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> cathotelsData = jsonDecode(res.body);
        List<Review> reviews = [];
        for (var cathotelData in cathotelsData) {
          var cathotelReviews =
              List<Map<String, dynamic>>.from(cathotelData['reviews']);
          reviews.addAll(
              cathotelReviews.map((reviewData) => Review.fromMap(reviewData)));
        }
        return reviews;
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }
  
  //รีวิว
  Future<void> addReview({
    required BuildContext context,
    required String user_id,
    required String message,
    required double rating,
    required String cathotelId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$url/addReview/$cathotelId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'user_id': user_id,
          'message': message,
          'rating': rating,
          'cathotelId': cathotelId
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รีวิวสำเร็จ!')),
        );
        Navigator.pop(context);
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
  }
}
