import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EditCommu extends StatefulWidget {
  final String commuId; // เพิ่มตัวแปรนี้

  const EditCommu({
    Key? key,
    required this.commuId, // เพิ่มตัวแปรนี้
  }) : super(key: key);

  @override
  State<EditCommu> createState() => _EditCommuState();
}

class _EditCommuState extends State<EditCommu> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isLoading = true;
  List<File> images = []; 
  List<String> imageUrls = []; 
  CommuServices commuServices =
      CommuServices(); // สร้าง instance ของ CommuServices

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    // ทำการโหลดข้อมูลโพสต์เดิม
    _loadPostData();
  }

  @override
  void dispose() {
    if (mounted) {
      _titleController.dispose();
      _descriptionController.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      await commuServices.editPost(
        context,
        widget.commuId,
        _titleController.text,
        _descriptionController.text,
        images,
      );
    }
  }

  Future<void> _loadPostData() async {
    try {
      // สมมติว่าคุณมีฟังก์ชันที่ชื่อว่า fetchPostById สำหรับดึงข้อมูลโพสต์
      final post = await commuServices.fetchIdCommu(context, widget.commuId);
      // นำข้อมูลเดิมมาใส่ใน TextEditingController
      _titleController.text = post.title;
      _descriptionController.text = post.description;
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
                          ? images.map(
                              (file) => Builder(
                                builder: (BuildContext context) => Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            ).toList()
                          : imageUrls.map(
                              (url) => Builder(
                                builder: (BuildContext context) => Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            ).toList(),
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
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit',style: TextStyle(color: Colors.white,)),
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
