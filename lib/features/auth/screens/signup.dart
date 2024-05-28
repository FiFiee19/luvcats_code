import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  List<File>? imageP;

  //เลือกรูปภาพ
  void selectImages() async {
    var res = await pickImagesFiles(false);
    setState(() {
      imageP = res;
    });
  }

  //สมัครสมาชิก
  void signupUser() async {
    if (signupFormKey.currentState!.validate() &&
        passwordConfirmed() &&
        imageP != null &&
        imageP!.isNotEmpty) {
      //บันทึกภาพลง Cloudinary
      final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
      CloudinaryResponse resimg = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageP![0].path,
            folder: "ImageP/user", publicId: _nameController.text),
      );
      print(resimg.secureUrl);

      authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
        imagesP: resimg.secureUrl,
      );
    } else {
      if (!passwordConfirmed()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('รหัสผ่านไม่ตรงกัน'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (imageP == null || imageP!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาเลือกรูปภาพ'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == _cpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: signupFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  Text(
                    'LuvCats',
                    style:
                        GoogleFonts.gluten(fontSize: 60.0, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.pets,
                    color: Colors.red,
                    size: 30.0,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'สมัครสมาชิก',
                    style:
                        GoogleFonts.gluten(fontSize: 20.0, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              imageP == null || imageP!.isEmpty
                  ? const CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: Image.file(
                        imageP![0],
                        fit: BoxFit.cover,
                      ).image,
                      backgroundColor: Colors.white,
                    ),
              Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: GestureDetector(
                    onTap: () {
                      selectImages();
                    },
                    child: const Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกชื่อ';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'ชื่อ',
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
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    } else if (!RegExp(r'^[A-Za-z\d]+$').hasMatch(val)) {
                      return 'รหัสผ่านต้องเป็นตัวอักษรหรือตัวเลขเท่านั้น';
                    } else if (val.length < 8) {
                      return 'รหัสผ่านควรมีอักขระ 8 ตัวขึ้นไป';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'รหัสผ่าน',
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
                  controller: _cpasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกยืนยันรหัสผ่าน';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'ยืนยันรหัสผ่าน',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.black38,
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'ลงทะเบียน',
                onTap: signupUser,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ));
  }
}
