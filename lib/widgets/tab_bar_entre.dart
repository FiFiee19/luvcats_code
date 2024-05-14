import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/screens/dashboardscreen.dart';
import 'package:luvcats_app/features/entrepreneur/screens/notification_entre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/profile_entre.dart';

class TabBarEntre extends StatefulWidget {
  const TabBarEntre({Key? key}) : super(key: key);

  @override
  State<TabBarEntre> createState() => _TabBarEntreState();
}

class _TabBarEntreState extends State<TabBarEntre> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController;
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
          ProfileEntre(),
          NotificationEntre(),
          DashboardScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'การแจ้งเตือน'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'ภาพรวม'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
