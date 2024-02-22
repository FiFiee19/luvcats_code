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
  Future<List<Cathotel>> fetchAllCathotel(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Cathotel> cathotelList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getCathotel'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            cathotelList.add(
              Cathotel.fromJson(
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
    return cathotelList;
  }

  Future<Cathotel?> fetchCatIdProfile(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Cathotel? catprofile;

    try {
      final http.Response res = await http.get(
        Uri.parse(
            '$url/getCathotel/$user_id'), // Ensure $url is correctly defined
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        if (body.isNotEmpty) {
          // Assuming you want the first Cathotel object from the list
          catprofile = Cathotel.fromMap(body.first);
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

  Future<List<Review>> fetchReviews(BuildContext context, String cathotelId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    final http.Response res = await http.get(
      Uri.parse('$url/getReview/$cathotelId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      },
    );

    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final List<dynamic> commentsData = jsonDecode(res.body);
      print('Response data: $commentsData');

      return commentsData.map((data) {
        if (data is! Map<String, dynamic>) {
          print('Data is not a Map: $data');
          throw Exception('Data format error');
        }

        return Review.fromMap(data);
      }).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  } catch (e) {
    throw Exception('Error fetching reviews: $e');
  }
}


  Future<void> addReview({
    required BuildContext context,
    required String user_id,
    required String message,
    required double rating,
    required String cathotelId, // ถ้า post_id เป็นค่าที่จำเป็น ควรลบ ? ออก
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$url/addReview/$cathotelId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode(
            {'user_id': user_id, 'message': message, 'rating': rating}),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add Comment Success')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to add review');
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
}
