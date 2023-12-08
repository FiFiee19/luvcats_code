import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/models/user.dart';

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
  // final TextEditingController _imageController = TextEditingController();
  final AuthService authService = AuthService();
  bool _isNotValidate = false;
  File? file;
  String? urlImageProfile;
  bool isImageSelected = false;
  var user = User;
  File? _image;

  // void _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       print(pickedFile.path);
  //     } else {
  //       print("no img seleted");
  //     }
  //   });
  // }
  void _pickImage() async {
    var res = await pickImage();
    setState(() {
      _image = res;
    });
  }

  Future<void> signupUser(BuildContext context) async {
    if (passwordConfirmed() && _image != null) {
      final cloudinary = CloudinaryPublic('denfgaxvg', 'uszbstnu');
      CloudinaryResponse resimg = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_image!.path, folder: "a"),
      );
      print(resimg.secureUrl);

      authService.signUpUser(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
          username: _nameController.text,
          images: resimg.secureUrl,
          description: '');
    } else {
      if (!passwordConfirmed()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Enter the same password'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an image'),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Text(
                  'LuvCats',
                  style: GoogleFonts.gluten(fontSize: 60.0, color: Colors.red),
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.pets,
                  color: Colors.red,
                  size: 30.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'สมัครสมาชิก',
                  style: GoogleFonts.gluten(fontSize: 20.0, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            _image == null
                ? CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                  )
                : CircleAvatar(
                    radius: 100,
                    backgroundImage: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ).image,
                    backgroundColor: Colors.white,
                  ),
            Padding(
                padding: const EdgeInsets.only(left: 150),
                child: GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                )),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'สมัครสมาชิก',
                  style: GoogleFonts.gluten(fontSize: 20.0, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  errorStyle: TextStyle(color: Colors.grey),
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  hintText: "Username",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
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
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  errorStyle: TextStyle(color: Colors.grey),
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  hintText: "Email",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
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
                controller: _passwordController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  errorStyle: TextStyle(color: Colors.grey),
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  hintText: "Password",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
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
                controller: _cpasswordController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  errorStyle: TextStyle(color: Colors.grey),
                  errorText: _isNotValidate ? "Enter Proper Info" : null,
                  hintText: "ConfirmPassword",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
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
                    signupUser(context);
                  },
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.red, // สีพื้นหลังของปุ่ม
                      borderRadius:
                          BorderRadius.circular(10.0), // รูปร่างของปุ่ม
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "ลงทะเบียน",
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
                  "มีบัญชีอยู่แล้ว?",
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
                            builder: (context) => SigninScreen()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    ));
  }
}
