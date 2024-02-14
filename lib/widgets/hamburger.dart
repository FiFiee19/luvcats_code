import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({Key? key}) : super(key: key);

  // Method to sign out the user, encapsulated within the Hamburger widget for better cohesion.
  void _signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove any padding from the ListView.
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: 
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Page 1'),
            onTap: () {
              
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.train),
            title: const Text('Page 2'),
            onTap: () {
              
              Navigator.pop(context);
            },
          ),Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out',),
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
