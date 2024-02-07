import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/screens/notification_entre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/profile_entre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/report_entre.dart';

// import '../pages/commu.dart';

class TabBar_entre extends StatefulWidget {
  const TabBar_entre({Key? key}) : super(key: key);

  @override
  State<TabBar_entre> createState() => _TabBar_entreState();
}

class _TabBar_entreState extends State<TabBar_entre> {
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
          Profile_Entre(),
          Notification_Entre(),
          Report_Entre(),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
