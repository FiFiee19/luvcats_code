import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/straycat/services/cat_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:luvcats_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class PostStrayCat extends StatefulWidget {
  const PostStrayCat({super.key});

  @override
  State<PostStrayCat> createState() => _PostStrayCatState();
}

class _PostStrayCatState extends State<PostStrayCat> {
  final TextEditingController breedController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final CatServices catServices = CatServices();
  List<File> images = [];
  final _postCatFormKey = GlobalKey<FormState>();
  List<Cat>? cats;

  @override
  void dispose() {
    if (mounted) {
      breedController.dispose();
      descriptionController.dispose();
      provinceController.dispose();
      genderController.dispose();
    }
    super.dispose();
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   breedController.dispose();
  //   descriptionController.dispose();
  //   provinceController.dispose();
  //   genderController.dispose();
  // }

  void postcat() {
    if (_postCatFormKey.currentState!.validate() && images.isNotEmpty) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;
      final User user = userProvider.user;
      catServices.postcat(
        user: user,
        user_id: user_id,
        context: context,
        breed: breedController.text,
        description: descriptionController.text,
        province: provinceController.text,
        gender: genderController.text,
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
                CustomTextField(
                  controller: breedController,
                  hintText: 'สายพันธุ์',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: genderController,
                  hintText: 'เพศ',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: provinceController,
                  hintText: 'จังหวัด',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'รายละเอียด',
                  maxLines: 7,
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   if (mounted) {
  //     breedController.dispose();
  //     descriptionController.dispose();
  //     provinceController.dispose();
  //     genderController.dispose();
  //   }
  // }
}
