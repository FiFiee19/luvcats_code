import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/config/error.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileServices {
  Future<List<Commu>> fetchProfile(BuildContext context) async {
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
}
