import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/cathotel.dart';
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

Future<Cathotel?> fetchCatIdProfile(BuildContext context, String user_id) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  Cathotel? catprofile;

  try {
    final http.Response res = await http.get(
      Uri.parse('$url/getCathotel/$user_id'), // Ensure $url is correctly defined
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



}
