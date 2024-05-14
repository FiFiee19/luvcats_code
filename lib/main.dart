import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/map/screens/application_bloc.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MapApp()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const SigninScreen());
  }
}
