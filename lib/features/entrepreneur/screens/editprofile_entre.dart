import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class EditProfileEntre extends StatefulWidget {
  final String CathotelId;

  const EditProfileEntre({
    Key? key,
    required this.CathotelId,
  }) : super(key: key);

  @override
  State<EditProfileEntre> createState() => _EditProfileEntreState();
}

class _EditProfileEntreState extends State<EditProfileEntre> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  bool isLoading = true;
  List<File> images = [];
  List<String> imageUrls = [];
  EntreService entreService = EntreService();

  @override
  void initState() {
    super.initState();
    descriptionController;
    priceController;
    contactController;
    provinceController;
    _loadPostData();
  }

  @override
  void dispose() {
    if (mounted) {
      descriptionController.dispose();
      priceController.dispose();
      contactController.dispose();
      provinceController.dispose();
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final post =
          await entreService.fetchIdCathotel(context, userProvider.user.id);
      // นำข้อมูลเดิมมาใส่ใน TextEditingController
      priceController.text = post.price.toString();
      descriptionController.text = post.description;
      contactController.text = post.contact;
      provinceController.text = post.province;
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
        title: Text('แก้ไขโปรไฟล์'),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคา',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกราคา';
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
                      return 'กรุณากรอกช่องทางการติดต่อ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
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
                      provinceController.text = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'ลงทะเบียน',
                  onTap: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
