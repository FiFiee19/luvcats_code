import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/entrepreneur/screens/editentre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/review_entre.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/features/expense/screens/expensescreen.dart';
import 'package:luvcats_app/features/profile/screens/editpassword.dart';
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/entre.dart';
import 'package:provider/provider.dart';


class HamburgerEntre extends StatefulWidget {
  const HamburgerEntre({super.key});

  @override
  State<HamburgerEntre> createState() => _HamburgerEntreState();
}

class _HamburgerEntreState extends State<HamburgerEntre> {
  Entrepreneur? entre;
    EntreService entreServices = EntreService();

    @override
  void initState() {
    super.initState();
    fetchProfile();

  }

    Future<void> fetchProfile() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      entre =
        await entreServices.fetchIdEntre(context, userProvider.user.id);
        if (mounted) {
      setState(() {});
    }
    }
    void _signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(child: Text(user.email))),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('ข้อมูลผู้ประกอบการ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditEntreScreen(entreId: entre!.id)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star),
            title: const Text('รีวิวของร้าน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewEntre( cathotel: entre!.store_id)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.key),
            title: Text('เปลี่ยนรหัสผ่าน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPassword()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Sign Out',
            ),
            onTap: () {
              _signOutUser(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}