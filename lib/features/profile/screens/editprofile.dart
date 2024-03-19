import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  bool isLoading = true;
  File? imagesP; // รูปภาพที่เลือกใหม่
  String? imageUrl;

  ProfileServices profileServices = ProfileServices();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    if (mounted) {
      usernameController.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      User? updatedUser = await profileServices.editUser(
          context, usernameController.text, imagesP);
      // if (updatedUser != null) {
      //   Provider.of<UserProvider>(context, listen: false)
      //       .updateUser(username: usernameController.text, imagesP: imageUrl);
      // }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ดึง userId จาก UserProvider
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (userId != null) {
      _loadProfile(userId);
    }
  }

  Future<void> _loadProfile(String userId) async {
    try {
      final profile = await profileServices.fetchIdUser(context, userId);
      usernameController.text = profile.username;
      imageUrl = profile.imagesP;
    } catch (e) {
      print('Error loading post data: $e');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectImages() async {
    var res = await pickImageGallery();
    setState(() {
      imagesP = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('แก้ไขโปรไฟล์'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (imagesP != null)
                  Image.file(imagesP!, fit: BoxFit.cover, height: 200)
                else if (imageUrl != null)
                  Image.network(imageUrl!, fit: BoxFit.cover, height: 200)
                else
                  GestureDetector(
                    onTap: selectImages,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt,
                                color: Colors.grey, size: 50),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.upload_sharp,
                    ),
                    onPressed: () => selectImages(),
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('บันทึก',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      primary: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
