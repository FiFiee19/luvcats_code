import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  // final token;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AuthService().getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context).user;
    print(users);
    print(Provider.of<UserProvider>(context).user.toJson());

    return Scaffold(
      body: Center(
        child: Center(
            child: Text(
          users.username,
          style: TextStyle(color: Colors.black),
        )),
      ),
    );
  }
}
