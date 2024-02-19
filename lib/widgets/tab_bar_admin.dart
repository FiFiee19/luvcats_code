import 'package:flutter/material.dart';
import 'package:luvcats_app/features/admin/screens/commu_admin.dart';
import 'package:luvcats_app/features/admin/screens/notification_admin.dart';
import 'package:luvcats_app/features/admin/screens/staycats_admin.dart';
import 'package:luvcats_app/features/entrepreneur/screens/notification_entre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/profile_entre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/report_entre.dart';


class TabBar_admin extends StatefulWidget {
  const TabBar_admin({Key? key}) : super(key: key);

  @override
  State<TabBar_admin> createState() => _TabBar_adminState();
}

class _TabBar_adminState extends State<TabBar_admin> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      currentIndex = pageIndex;
    });
  }

  void onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          StrayCatAdmin(),
          CommuAdmin(),
          NotificationAdmin(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}