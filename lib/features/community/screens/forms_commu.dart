import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormsCommu extends StatefulWidget {
  const FormsCommu({Key? key,
  }) : super(key: key);

  @override
  State<FormsCommu> createState() => _FormsCommuState();
}

class _FormsCommuState extends State<FormsCommu> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CommuServices commuServices = CommuServices();
  List<File> images = [];
  final GlobalKey<FormState> postCommuFormKey = GlobalKey<FormState>();
  List<Commu>? commu;

  @override
  void dispose() {
    if (mounted) {
      titleController.dispose();
      descriptionController.dispose();
    }
    super.dispose();
  }

  //โพสต์Commu
  void postcommu() async {
    if (postCommuFormKey.currentState!.validate()) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;

      List<String> imageUrls = [];

      String uniqueFileName(String userId, int index) {
        var uuid = Uuid();
        return "${userId}/${uuid.v4()}/${index + 1}";
      }

      if (images.isNotEmpty) {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: "Community", publicId: uniqueFileName(user_id, i)),
          );
          imageUrls.add(res.secureUrl);
        }
      }

      if (!mounted) return;

      commuServices.postcommu(
        user_id: user_id,
        context: context,
        title: titleController.text,
        description: descriptionController.text,
        images: imageUrls,
      );
    }
  }

  void selectImages() async {
    var res = await pickImagesFiles(true);
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
          centerTitle: true,
          title: const Text('โพสต์'),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: postCommuFormKey,
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
                                  'เลือกรูปภาพ',
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
                      Icons.image,
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
                    maxLines: 7,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรายละเอียด';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'รายละเอียด',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'โพสต์',
                  onTap: () {
                    if (postCommuFormKey.currentState!.validate()) {
                      postcommu();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
