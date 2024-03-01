import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/screens/cathotelscreen.dart';
import 'package:luvcats_app/features/community/screens/commuscreen.dart';
import 'package:luvcats_app/features/map/screens/mapscreen.dart';
import 'package:luvcats_app/features/profile/screens/profilescreen.dart';
import 'package:luvcats_app/features/straycat/screens/straycatscreen.dart';

// import '../pages/commu.dart';

class tab_Bar extends StatefulWidget {
  const tab_Bar({Key? key}) : super(key: key);

  @override
  State<tab_Bar> createState() => _tab_BarState();
}

class _tab_BarState extends State<tab_Bar> {
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
          StrayCatScreen(),
          CatHotelScreen(),
          CommuScreen(),
          Map_Cat(),
          ProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'ร้านค้า'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'คอมมูนิตี้'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'แผนที่'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
