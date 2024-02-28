import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/providers/commu_provider.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CommuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Provider.of<UserProvider>(context).user.token.isEmpty
            ? const SigninScreen() // ถ้าไม่มี Token, ไปที่หน้า SigninScreen
            : const Home());
  }
}
