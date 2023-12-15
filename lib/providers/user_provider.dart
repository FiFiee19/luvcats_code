import 'package:flutter/material.dart';
import 'package:luvcats_app/models/user.dart';

//ChangeNotifier คือแจ้งเตือนเมื่อมีการเปลี่ยนแปลงข้อมูล
class UserProvider extends ChangeNotifier {
  User _user = User(
    id: "",
    username: "",
    email: "",
    token: "",
    password: "",
    type: "",
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  
}
