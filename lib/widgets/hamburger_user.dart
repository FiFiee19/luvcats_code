import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/expense/screens/expensescreen.dart';
import 'package:luvcats_app/features/profile/screens/editpassword.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HamburgerUser extends StatelessWidget {
  
  const HamburgerUser({Key? key}) : super(key: key);

  void _signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
            leading: Icon(Icons.notifications),
            title: const Text('การแจ้งเตือน'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calculate),
            title: const Text('บันทึกค่าใช้จ่าย'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseScreen()),
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
