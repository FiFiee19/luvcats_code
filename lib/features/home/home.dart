import 'package:flutter/material.dart';
import 'package:luvcats_app/widgets/app_bar.dart';
import 'package:luvcats_app/widgets/hamburger.dart';
import 'package:luvcats_app/widgets/tab_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? tokenUser;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authtoken');
    print(token);
    setState(() {
      tokenUser = token ?? "No token";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'LuvCats',style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
    drawer: Hamburger(), body: const tab_Bar());
  }
}
