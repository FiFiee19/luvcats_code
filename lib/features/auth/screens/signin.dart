import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/features/auth/screens/signup.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/entrepreneur/screens/signup_entre.dart';
import 'package:luvcats_app/widgets/custom_button.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final GlobalKey<FormState> signinFormKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //เข้าสู่ระบบ
  void signinUser() {
    if (signinFormKey.currentState!.validate()) {
      authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: signinFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LuvCats',
                            style: GoogleFonts.gluten(
                                fontSize: 60.0, color: Colors.red),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.pets,
                            color: Colors.red,
                            size: 30.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'เข้าสู่ระบบ',
                            style: GoogleFonts.gluten(
                                fontSize: 20.0, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'กรุณากรอกอีเมล';
                                  } else if (RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$')
                                      .hasMatch(val)) {
                                    return null;
                                  } else {
                                    return 'ที่อยู่อีเมลไม่ถูกต้อง';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'อีเมล',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Colors.black38,
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: 'รหัสผ่าน',
                                  suffixIcon: IconButton(
                                    onPressed: _toggle,
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                },
                                obscureText: _obscureText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'เข้าสู่ระบบ',
                        onTap: signinUser,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "คุณมีบัญชีหรือยัง?",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()));
                            },
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "สมัครสมาชิก",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "เป็นผู้ประกอบการไหม?",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FormsEntre()));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "สมัครเป็นผู้ประกอบการ",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
