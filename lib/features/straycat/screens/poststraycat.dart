import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/straycat/services/cat_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class PostStrayCat extends StatefulWidget {
  const PostStrayCat({super.key});

  @override
  State<PostStrayCat> createState() => _PostStrayCatState();
}

class _PostStrayCatState extends State<PostStrayCat> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final CatServices catServices = CatServices();
  List<File> images = [];
  final _postCatFormKey = GlobalKey<FormState>();
  List<Cat>? cats;
  String selectedGender = 'ไม่ทราบ';
  String selectedProvince = 'กรุงเทพมหานคร';
  final List<String> listgender = [
    'ผู้',
    'เมีย',
    'ไม่ทราบ',
  ];

  @override
  void dispose() {
    if (mounted) {
      textEditingController.dispose();
      breedController.dispose();
      descriptionController.dispose();
      provinceController.dispose();
    }
    super.dispose();
  }

  void postcat() {
    if (_postCatFormKey.currentState!.validate() && images.isNotEmpty) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;

      catServices.postcat(
        user_id: user_id,
        context: context,
        breed: breedController.text,
        description: descriptionController.text,
        province: selectedProvince,
        gender: selectedGender,
        images: images,
      );
    }
  }

  void selectImages() async {
    var res = await pickImages();
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
          key: _postCatFormKey,
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
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
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
                const SizedBox(height: 30),
                TextField(
                  controller: breedController,
                  decoration: InputDecoration(
                    hintText: 'สายพันธุ์',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          15), // ใช้พารามิเตอร์ borderRadius ที่นี่
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // การตกแต่งอื่นๆ...
                  ),
                  hint: const Text(
                    'เพศ',
                    style: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกเพศ';
                    }
                    return null;
                  },
                  items: listgender.map((String selectedGender) {
                    return DropdownMenuItem<String>(
                      value: selectedGender,
                      child: Text(
                        selectedGender,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  // ตัวเลือกอื่นๆ...
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // การตกแต่งอื่นๆ...
                  ),
                  hint: const Text(
                    'จังหวัด',
                    style: TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกจังหวัด';
                    }
                    return null;
                  },
                  items: province.map((String selectedProvince) {
                    return DropdownMenuItem<String>(
                      value: selectedProvince,
                      child: Text(
                        selectedProvince,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProvince = value!;
                    });
                  },
                  // ตัวเลือกอื่นๆ...
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: 'รายละเอียด',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          15), // ใช้พารามิเตอร์ borderRadius ที่นี่
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    // การตกแต่งอื่นๆ...
                  ),
                  // คุณสมบัติอื่นๆ...
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Post',
                  onTap: postcat,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
