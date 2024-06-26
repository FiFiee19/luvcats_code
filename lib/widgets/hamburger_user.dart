import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/dashboard/screens/dashboard_straycat.dart';
import 'package:luvcats_app/features/expense/screens/expensescreen.dart';
import 'package:luvcats_app/features/notifications/screens/notification.dart';
import 'package:luvcats_app/features/profile/screens/editpassword.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HamburgerUser extends StatelessWidget {
  const HamburgerUser({Key? key}) : super(key: key);

  void _signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final CatServices catServices = CatServices();
    final user = Provider.of<UserProvider>(context).user;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(child: Text(user.email))),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('การแจ้งเตือน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationUser()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('บันทึกค่าใช้จ่าย'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpenseScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('เปลี่ยนรหัสผ่าน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditPassword()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'ออกจากระบบ',
            ),
            onTap: () {
              _signOutUser(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text(
            'สถิติ',
            style: TextStyle(fontSize: 20),
          )),
          DashboardStraycat(
            catData: catServices.fetchAllCats(context),
          ),
        ],
      ),
    );
  }
}
