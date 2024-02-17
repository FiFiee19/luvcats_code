import 'package:flutter/material.dart';
import 'package:luvcats_app/widgets/tab_bar_admin.dart';


class HomeSreenAdmin extends StatelessWidget {
  const HomeSreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'LuvCats',style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
    // drawer: HamburgerEntre(),
      body: TabBar_admin()
    );
  }
}