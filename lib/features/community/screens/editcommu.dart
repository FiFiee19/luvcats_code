import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';

class EditCommu extends StatefulWidget {
  final String commuId;

  const EditCommu({
    Key? key,
    required this.commuId,
  }) : super(key: key);

  @override
  State<EditCommu> createState() => _EditCommuState();
}

class _EditCommuState extends State<EditCommu> {
  final GlobalKey<FormState> commuFormKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = true;
  List<File> images = [];
  List<String> imageUrls = [];
  CommuServices commuServices = CommuServices();

  @override
  void initState() {
    super.initState();
    fetchCommu();
    titleController.text;
    descriptionController.text;
    print(widget.commuId);
  }

  @override
  void dispose() {
    if (mounted) {
      titleController.dispose();
      descriptionController.dispose();
    }
    super.dispose();
  }

  //แก้ไขข้อมูล
  void submitForm() async {
    if (commuFormKey.currentState!.validate()) {
      await commuServices.editPostCommu(
        context,
        widget.commuId,
        titleController.text,
        descriptionController.text,
        images,
      );
    }
  }

  //เรียกข้อมูลCommuจากcommuServices
  Future<void> fetchCommu() async {
    try {
      final commu = await commuServices.fetchIdCommu(context, widget.commuId);
      titleController.text = commu.title;
      descriptionController.text = commu.description;
      imageUrls = commu.images;
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
    var res = await pickImagesFiles(true);
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('แก้ไขโพสต์'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: commuFormKey,
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
                      Icons.image,
                    ),
                    onPressed: () => selectImages(),
                  ),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'หัวข้อ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกหัวข้อ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                  ),
                  maxLines: 7,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitForm,
                  child: Text('บันทึก',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
