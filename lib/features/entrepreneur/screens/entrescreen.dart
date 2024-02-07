import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/widgets/tab_bar_entre.dart';
import 'package:luvcats_app/widgets/app_bar.dart';

class HomeScreen_Entre extends StatefulWidget {
  const HomeScreen_Entre({super.key});

  @override
  State<HomeScreen_Entre> createState() => _HomeScreen_EntreState();
}

class _HomeScreen_EntreState extends State<HomeScreen_Entre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: TabBar_entre(),
    );
  }
}
