import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/features/auth/screens/signup.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/entrepreneur/screens/forms_entre.dart';
import 'package:luvcats_app/widgets/custom_textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final _signinFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //เข้าสู่ระบบ
  void signinUser() {
    if (_signinFormKey.currentState!.validate()) {
      authService.signInUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: _signinFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 300),
                          Text(
                            'LuvCats',
                            style: GoogleFonts.gluten(
                                fontSize: 60.0, color: Colors.red),
                          ),
                          // SizedBox(height: 10),
                          Icon(
                            Icons.pets,
                            color: Colors.red,
                            size: 30.0,
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              hintText: 'อีเมล',
                            ),
                           
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: 'รหัสผ่าน',
                                  
                                  // เพิ่มปุ่มเพื่อเปิด/ซ่อน รหัสผ่าน
                                  suffixIcon: IconButton(
                                    onPressed:
                                        _toggle, // เรียกใช้งานฟังก์ชัน _toggle เมื่อปุ่มถูกกด
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                },
                                obscureText:
                                    _obscureText, // ใช้งานค่า _obscureText เพื่อซ่อนรหัสผ่าน
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              signinUser();
                            },
                            child: Container(
                              width: 200.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.red, // สีพื้นหลังของปุ่ม
                                borderRadius: BorderRadius.circular(
                                    10.0), // รูปร่างของปุ่ม
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()));
                            },
                            child: Column(
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "เป็นผู้ประกอบการไหม?",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormsEntre()));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "สมัครเป็นผู้ประกอบการ",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
