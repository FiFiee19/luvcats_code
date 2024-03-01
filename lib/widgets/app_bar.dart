import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';

void signOutUser(BuildContext context) {
  AuthService().signOut(context);
}

AppBar customAppBar(BuildContext context) {
  return AppBar(
    title: Center(
      child: Text(
        'LuvCats',
        style: GoogleFonts.kanit(
          color: Color.fromARGB(255, 247, 108, 185),
          fontSize: 30.0,
        ),
      ),
    ),
   
    actions: [
      TextButton(
        onPressed: () {
          signOutUser(context);
        },
        child: Row(
          children: [
            Icon(Icons.logout), 
            SizedBox(width: 5), 
            Text('Sign Out'), 
          ],
        ),
      ),
    ],
    backgroundColor: Colors.white,
  );
}
