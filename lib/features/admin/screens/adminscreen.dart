import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/widgets/tab_bar_admin.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  //ออกจากระบบ
  void _signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'LuvCats',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
                onPressed: () {
                  _signOutUser(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
          ],
        ),
        body: const TabBarAdmin());
  }
}
