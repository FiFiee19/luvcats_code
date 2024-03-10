import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/profileofuser/screens/onescreenofuser.dart';
import 'package:luvcats_app/features/profileofuser/screens/twosreenofuser.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileOfUser extends StatefulWidget {
  final User user;
  const ProfileOfUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileOfUser> createState() => _ProfileOfUserState();
}

class _ProfileOfUserState extends State<ProfileOfUser> {
  User? users;
  ProfileServices profileServices = ProfileServices();
  bool isLoading = true;
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // @override
  // void initState() {
  //   fetchProfile(user.id);

  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   fetchProfile(userId);
    // }
    // );
    _pages = [
      OneScreen1(user: widget.user), // Use widget.user instead of user
      TwoScreen2(user: widget.user), // Use widget.user
    ];
    print('User ID: $widget.user');
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
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(),
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
                  backgroundImage: NetworkImage(
                    widget.user.imagesP,
                  ),
                  radius: 50,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  widget.user.username,
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
  final User user;

  const OneScreen1({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OneScreenOfUser(user: user);
  }
}

class TwoScreen2 extends StatelessWidget {
  final User user;

  const TwoScreen2({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TwoSreenOfUser(user: user);
  }
}
