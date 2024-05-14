import 'package:flutter/material.dart';
import 'package:luvcats_app/features/admin/screens/notification_admin.dart';
import 'package:luvcats_app/features/community/screens/commuscreen.dart';
import 'package:luvcats_app/features/straycat/screens/straycatscreen.dart';

class TabBarAdmin extends StatefulWidget {
  const TabBarAdmin({Key? key}) : super(key: key);

  @override
  State<TabBarAdmin> createState() => _TabBarAdminState();
}

class _TabBarAdminState extends State<TabBarAdmin> {
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
          StrayCatScreen(),
          CommuScreen(),
          NotificationAdmin(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'คอมมูนิตี้'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'การแจ้งเตือน'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
