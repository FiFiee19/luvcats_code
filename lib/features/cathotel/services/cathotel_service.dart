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
}
