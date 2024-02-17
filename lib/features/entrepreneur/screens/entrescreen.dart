import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/widgets/tab_bar_entre.dart';
import 'package:luvcats_app/widgets/app_bar.dart';
import 'package:luvcats_app/widgets/hamburger_entre.dart';
import 'package:luvcats_app/widgets/hamburger_user.dart';

class HomeScreen_Entre extends StatefulWidget {
  const HomeScreen_Entre({super.key});

  @override
  State<HomeScreen_Entre> createState() => _HomeScreen_EntreState();
}

class _HomeScreen_EntreState extends State<HomeScreen_Entre> {
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
    drawer: HamburgerEntre(),
      body: TabBar_entre(),
    );
  }
}
