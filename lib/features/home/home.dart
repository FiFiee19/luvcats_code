import 'package:flutter/material.dart';
import 'package:luvcats_app/widgets/app_bar.dart';
import 'package:luvcats_app/widgets/tab_bar.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: customAppBar(context), body: const tab_Bar());
  }
}
