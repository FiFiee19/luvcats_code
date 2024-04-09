import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/screens/editprofile.dart';
import 'package:luvcats_app/features/profile/screens/onescreen.dart';
import 'package:luvcats_app/features/profile/screens/twoscreen.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? users;
  final ProfileServices profileServices = ProfileServices();
  bool isLoading = true;
  int _selectedIndex = 0;
  User? fetchedUser;
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
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (userId != null) {
      fetchProfile(userId);
    }
  }

  Future<void> fetchProfile(String userId) async {
    fetchedUser = await profileServices.fetchIdUser(context, userId);
    if (fetchedUser != null && mounted) {
      setState(() {
        users = fetchedUser;
        isLoading = false;
      });
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
                  MaterialPageRoute(builder: (context) => const Editprofile()),
                );
                if (result != null && users != null) {
                  await fetchProfile(users!.id);
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      users != null ? NetworkImage(users!.imagesP) : null,
                  radius: 50,
                ),
                const SizedBox(width: 30),
                Text(
                  users?.username ?? '',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            items: const [
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
    return const OneScreen();
  }
}

class TwoScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const TwoScreen();
  }
}
