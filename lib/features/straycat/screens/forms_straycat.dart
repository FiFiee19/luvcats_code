import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormsStrayCat extends StatefulWidget {
  const FormsStrayCat({
    Key? key,
  }) : super(key: key);

  @override
  State<FormsStrayCat> createState() => _FormsStrayCatState();
}

class _FormsStrayCatState extends State<FormsStrayCat> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final CatServices catServices = CatServices();
  List<File> images = [];
  final GlobalKey<FormState> postCatFormKey = GlobalKey<FormState>();
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

  void postcat() async {
    if (postCatFormKey.currentState!.validate()) {
      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('กรุณาเลือกรูปภาพ'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        final String user_id = userProvider.user.id;

        List<String> imageUrls = [];
        var uuid = Uuid();
        String folderPath = "Straycat/${user_id}/${uuid.v4()}";

        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: folderPath, publicId: "รูปที่${i + 1}"),
          );
          imageUrls.add(res.secureUrl);
        }

        catServices.postcat(
          user_id: user_id,
          context: context,
          breed: breedController.text,
          description: descriptionController.text,
          province: selectedProvince,
          gender: selectedGender,
          images: imageUrls,
        );
      }
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
          preferredSize: const Size.fromHeight(50), child: AppBar()),
      body: SingleChildScrollView(
        child: Form(
          key: postCatFormKey,
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
                    controller: breedController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกสายพันธุ์';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'สายพันธุ์',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
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
