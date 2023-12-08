import 'package:flutter/material.dart';
import 'package:luvcats_app/models/user.dart';
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
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    
    

    return Scaffold(
      body: Center(
        child: Text(
          user.username,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
