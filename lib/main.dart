import 'package:flutter/material.dart';
import 'package:luvcats_app/features/admin/screens/home_admin.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/home/home.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context).user.username);
    return MaterialApp(
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? const SigninScreen() // ถ้าไม่มี Token, ไปที่หน้า SigninScreen
          : Provider.of<UserProvider>(context).user.type == 'admin'
              ? const AdminScreen() // ถ้ามี Token และเป็น User, ไปที่หน้า Home
              : const Home(), // ถ้ามี Token แต่ไม่ใช่ User, ไปที่หน้า AdminScreen
    );
  }
}
