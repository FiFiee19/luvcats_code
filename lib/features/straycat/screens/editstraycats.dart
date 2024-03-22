import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';

class EditStraycats extends StatefulWidget {
  final String starycatsId;

  const EditStraycats({
    Key? key,
    required this.starycatsId,
  }) : super(key: key);

  @override
  State<EditStraycats> createState() => _EditStraycatsState();
}

class _EditStraycatsState extends State<EditStraycats> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController breedController;
  late TextEditingController descriptionController;
  late TextEditingController provinceController;
  late TextEditingController genderController;
  bool isLoading = true;
  List<File> images = []; //รูปใหม่
  List<String> imageUrls = []; //รูปเก่า
  CatServices catServices = CatServices();
  final List<String> listgender = [
    'ผู้',
    'เมีย',
    'ไม่ทราบ',
  ];

  @override
  void initState() {
    super.initState();
    breedController = TextEditingController();
    descriptionController = TextEditingController();
    provinceController = TextEditingController();
    genderController = TextEditingController();
    // ทำการโหลดข้อมูลโพสต์เดิม
    _loadPostData();
  }

  void selectImages() async {
    var res = await pickImagesFiles();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    if (mounted) {
      breedController.dispose();
      genderController.dispose();
      provinceController.dispose();
      descriptionController.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      // ตรวจสอบว่ามีการเลือกรูปภาพใหม่หรือไม่
      await catServices.editPostCat(
          context,
          widget.starycatsId,
          breedController.text,
          genderController.text,
          provinceController.text,
          descriptionController.text,
          images // ใช้รูปใหม่ที่เลือก
          );
    }
  }

  Future<void> _loadPostData() async {
    try {
      final post =
          await catServices.fetchIdStraycats(context, widget.starycatsId);

      breedController.text = post.breed;
      genderController.text = post.gender;
      provinceController.text = post.province;
      descriptionController.text = post.description;
      imageUrls = post.images;
    } catch (e) {
      print('Error loading post data: $e');
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโพสต์'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (images != null || imageUrls != null)
                  CarouselSlider(
                    items: images.isNotEmpty
                        ? images
                            .map(
                              (file) => Builder(
                                builder: (BuildContext context) => Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            )
                            .toList()
                        : imageUrls
                            .map(
                              (url) => Builder(
                                builder: (BuildContext context) =>
                                    Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            )
                            .toList(),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: 200,
                    ),
                  )
                else
                  GestureDetector(
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
                      Icons.upload_sharp,
                    ),
                    onPressed: () => selectImages(),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: 'สายพันธุ์',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกสายพันธุ์';
                    }
                    return null;
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
                  value: genderController.text.isNotEmpty
                      ? genderController.text
                      : null,
                  items: listgender.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(
                        gender,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      genderController.text = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
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
                  value: provinceController.text.isNotEmpty
                      ? provinceController.text
                      : null,
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
                      provinceController.text = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
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
                      backgroundColor: Colors.red,
                      // primary: Colors.red
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
