import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luvcats_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: "",
    username: "",
    email: "",
    token: "",
    password: "",
    type: "",
    imagesP: "",
  );

  User get user => _user;

  void setUser(String userJson) {
    var decodedJson = json.decode(userJson);

    if (decodedJson['user'] != null) {
      _user = User.fromMap(decodedJson['user']);
    }

    if (decodedJson['token'] != null) {
      _user.token = decodedJson['token'];
    }
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
