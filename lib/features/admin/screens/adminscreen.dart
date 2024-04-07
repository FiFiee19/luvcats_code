import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/widgets/tab_bar_admin.dart';

class HomeSreenAdmin extends StatelessWidget {
  const HomeSreenAdmin({super.key});

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
                child: Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
            // ElevatedButton.icon(
            //     onPressed: () {
            //       _signOutUser(context);
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(Icons.logout),
            //     label: Text(''))
          ],
        ),
        body: TabBar_admin());
  }
}
