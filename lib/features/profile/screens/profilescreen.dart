import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/screens/editprofile.dart';
import 'package:luvcats_app/features/profile/screens/onescreen.dart';
import 'package:luvcats_app/features/profile/screens/twoscreen.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? users;
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ดึง userId จาก UserProvider
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (userId != null) {
      fetchProfile(userId);
    }
  }

  Future<void> fetchProfile(String userId) async {
    try {
      User? fetchedUser = await profileServices.fetchIdUser(context, userId);
      if (fetchedUser != null && mounted) {
        setState(() {
          users = fetchedUser;
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 100),
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
                if (result != null && users != null) {
                  await fetchProfile(
                      users!.id); // Only refresh if `users` is non-null
                  setState(() {}); // Force the UI to refresh
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.grey),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      users != null ? NetworkImage(users!.imagesP) : null,
                  radius: 50,
                ),
                SizedBox(width: 30),
                Text(
                  users?.username ??
                      '', // Use a fallback value like an empty string if `users` is null
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
