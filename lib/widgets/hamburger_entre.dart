import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/entrepreneur/screens/editentre.dart';
import 'package:luvcats_app/features/entrepreneur/screens/review_entre.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/features/profile/screens/editpassword.dart';
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HamburgerEntre extends StatefulWidget {
  const HamburgerEntre({
    Key? key,
  }) : super(key: key);

  @override
  State<HamburgerEntre> createState() => _HamburgerEntreState();
}

class _HamburgerEntreState extends State<HamburgerEntre> {
  Entrepreneur? entre;
  final EntreService entreServices = EntreService();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    entre = await entreServices.fetchIdEntre(context, userProvider.user.id);
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
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(child: Text(user.email))),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text('ข้อมูลผู้ประกอบการ'),
              onTap: () {
                if (entre != null) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditEntreScreen(entreId: entre!.id)),
                  );
                }
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('รีวิวของร้าน'),
            onTap: () {
              if (entre != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReviewEntre(cathotel: entre!.store_id)),
                );
              } else {
                debugPrint(
                    'Error: trying to navigate to ReviewEntre with a null entre');
              }
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
        ],
      ),
    );
  }
}
