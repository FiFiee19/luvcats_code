import 'package:flutter/material.dart';
import 'package:luvcats_app/widgets/hamburger_user.dart';
import 'package:luvcats_app/widgets/tab_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('LuvCats', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
        drawer: const HamburgerUser(),
        body: const Tab_Bar());
  }
}
