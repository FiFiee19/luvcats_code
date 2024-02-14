import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/screens/editprofile.dart';
import 'package:luvcats_app/features/profile/screens/onescreen.dart';
import 'package:luvcats_app/features/profile/screens/twoscreen.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/hamburger.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  ProfileServices profileServices = ProfileServices();
  bool isLoading = true;
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
  void initState() {
    fetchProfile();
    super.initState();
  }

  Future<void> fetchProfile() async {
    user = await profileServices.fetchIdUser(context);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'LuvCats',style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
    drawer: Hamburger(),
    backgroundColor: Colors.white,
  
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: Column(
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
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Editprofile()),
                  );
                  if (result != null) {
                    await fetchProfile(); // รีเฟรชข้อมูลผู้ใช้
                    setState(() {}); // บังคับให้ UI รีเฟรช
                  }
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
