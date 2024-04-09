import 'package:flutter/material.dart';
import 'package:luvcats_app/widgets/hamburger_entre.dart';
import 'package:luvcats_app/widgets/tab_bar_entre.dart';


class HomeScreenEntre extends StatelessWidget {
  const HomeScreenEntre({
    Key? key,
  }) : super(key: key);

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
      ),
      drawer: const HamburgerEntre(),
      body: const TabBarEntre(),
    );
  }
}
