import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';

class EditProfileEntre extends StatefulWidget {
  final String CathotelId; // เพิ่มตัวแปรนี้

  const EditProfileEntre({
    Key? key,
    required this.CathotelId, // เพิ่มตัวแปรนี้
  }) : super(key: key);

  @override
  State<EditProfileEntre> createState() => _EditProfileEntreState();
}

class _EditProfileEntreState extends State<EditProfileEntre> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController provinceController;
  late TextEditingController contactController;
  bool isLoading = true;
  List<File> images = [];
  List<String> imageUrls = [];
  EntreService entreService = EntreService(); // สร้าง instance ของ CommuServices
  // String selectedGender = 'ไม่ทราบ';
  // String selectedProvince = 'กรุงเทพมหานคร';
  

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    provinceController = TextEditingController();
    contactController = TextEditingController();
    // ทำการโหลดข้อมูลโพสต์เดิม
    _loadPostData();
  }

  @override
  void dispose() {
    if (mounted) {
      priceController.dispose();
      descriptionController.dispose();
      provinceController.dispose();
      contactController.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      await entreService.editProfileEntre(
        context,
        widget.CathotelId,
        double.parse(priceController.text),
        contactController.text,
        descriptionController.text,
        provinceController.text,
        
        images,
      );
    }
  }

  Future<void> _loadPostData() async {
    try {
      // สมมติว่าคุณมีฟังก์ชันที่ชื่อว่า fetchPostById สำหรับดึงข้อมูลโพสต์
      final post =
          await entreService.fetchIdCathotel(context, widget.CathotelId);
      // นำข้อมูลเดิมมาใส่ใน TextEditingController
      priceController.text = post.province;
      descriptionController.text = post.description;
      provinceController.text = post.province;
      contactController.text = post.contact;
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

  void selectImages() async {
    var res = await pickImagesFiles();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Community Post'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                images.isNotEmpty || imageUrls.isNotEmpty
                    ? Column(
                        children: [
                          CarouselSlider(
                            items: images.isNotEmpty
                                ? images
                                    .map(
                                      (file) => Builder(
                                        builder: (BuildContext context) =>
                                            Image.file(
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
                          ),
                        ],
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
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคา',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'ช่องทางการติดต่อ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                
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
