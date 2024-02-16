import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:luvcat_app/services/auth_services.dart';

class FormsCommu extends StatefulWidget {
  const FormsCommu({super.key});

  @override
  State<FormsCommu> createState() => _FormsCommuState();
}

class _FormsCommuState extends State<FormsCommu> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CommuServices commuServices = CommuServices();
  List<File> images = [];
  final _postCommuFormKey = GlobalKey<FormState>();
  List<Commu>? commu;

  @override
  void dispose() {
    if (mounted) {
      titleController.dispose();
      descriptionController.dispose();
    }
    super.dispose();
  }

  void postcommu() {
    if (_postCommuFormKey.currentState!.validate()) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;
      commuServices.postcommu(
        user_id: user_id,
        context: context,
        title: titleController.text,
        description: descriptionController.text,
        images: images,
      );
    }
  }

  void selectImages() async {
    var res = await pickImagesFiles();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: Center(
              child: Text(
                'LuvCats',
                style: GoogleFonts.kanit(
                  color: Color.fromARGB(255, 247, 108, 185),
                  fontSize: 30.0,
                ),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Form(
            key: _postCommuFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  images.isNotEmpty
                      ? CarouselSlider(
                          items: images.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) => Image.file(
                                  i,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
                          ),
                        )
                      : GestureDetector(
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
                                children: [
                                  
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select Images',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
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
                  const SizedBox(height: 30),
                  Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกหัวเรื่อง';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'หัวเรื่อง',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                  Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 2,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรายละเอียด';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'รายละเอียด',
                      
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          
                          borderSide: BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: postcommu,
                    child: const Text('โพสต์',style: TextStyle(color: Colors.white,)),
                    style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50), primary: Colors.red),
                  ),
                ],
              ),
            ),
          ),
      ),
      
    );
  }
}
