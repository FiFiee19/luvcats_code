import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/screens/editprofile.dart';
import 'package:luvcats_app/features/profile/screens/onescreen.dart';
import 'package:luvcats_app/features/profile/screens/twoscreen.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    OneScreen1(),
    TwoScreen2(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 220),
            child: ElevatedButton(
              child: Text(
                'แก้ไขโปรไฟล์',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Editprofile(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    user.imagesP,
                  ),
                  radius: 50,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  user.username,
                  style: Theme.of(context).textTheme.subtitle1!.merge(
                        const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.view_module_outlined,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: onTabTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
          ),
          Expanded(
            child: _pages.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

class OneScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OneScreen();
  }
}

class TwoScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TwoScreen();
  }
}
