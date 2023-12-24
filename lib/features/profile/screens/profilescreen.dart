import 'package:flutter/material.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ListView(
        children: [
          ListTile(
            title: Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(user.email),
          ),
          // Add more ListTiles for other user info if needed
        ],
      ),
    );
  }
}
