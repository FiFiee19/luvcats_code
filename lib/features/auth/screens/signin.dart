import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/features/auth/screens/signup.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
   final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _isNotValidate = false;

   void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LuvCats',
                style: GoogleFonts.gluten(fontSize: 60.0, color: Colors.red),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.pets,
                color: Colors.red,
                size: 30.0,
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เข้าสู่ระบบ',
                style: GoogleFonts.gluten(fontSize: 20.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                errorStyle: TextStyle(color: Colors.grey),
                errorText: _isNotValidate ? "Enter Proper Info" : null,
                hintText: "Email",
                hintStyle: TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                errorStyle: TextStyle(color: Colors.grey),
                errorText: _isNotValidate ? "Enter Proper Info" : null,
                hintText: "Password",
                hintStyle: TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  loginUser();
                },
                child: Container(
                  width: 200.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.red, // สีพื้นหลังของปุ่ม
                    borderRadius: BorderRadius.circular(10.0), // รูปร่างของปุ่ม
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุณมีบัญชีหรือยัง?",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "สมัครสมาชิก",
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
