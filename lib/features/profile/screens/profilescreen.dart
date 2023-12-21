import 'package:flutter/material.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null || user.username.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // For security reasons, we don't display the token on the Profile screen
    // If you need to display it for debugging purposes, you can print it to the console
    // print('Token: ${user.token}');

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
// import 'package:flutter/material.dart';
// import 'package:luvcats_app/features/auth/services/auth_service.dart';
// import 'package:luvcats_app/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatefulWidget {
//   // final token;
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     AuthService().getUserData(context);
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     final users = Provider.of<UserProvider>(context).user;
//     print(users);

//     print(Provider.of<UserProvider>(context).user.toJson());

//     return Scaffold(
//       body: Center(
//         child: Center(
//             child: Text(
//           users.username,
//           style: TextStyle(color: Colors.black),
//         )),
//       ),
//     );
//   }
// }
