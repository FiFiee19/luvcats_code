import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormsEntre extends StatefulWidget {
  const FormsEntre({
    Key? key,
  }) : super(key: key);

  @override
  State<FormsEntre> createState() => _FormsEntreState();
}

class _FormsEntreState extends State<FormsEntre> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController store_addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final EntreService entreService = EntreService();
  List<File> images = [];
  final _formsEntreFormKey = GlobalKey<FormState>();
  Cathotel? cathotel;
  List<File>? _imageP;
  String selectedProvince = 'กรุงเทพมหานคร';

  void _pickImage() async {
    var res = await pickImagesFiles(false);
    if (!mounted) return;
    setState(() {
      _imageP = res;
    });
  }

  void formsentre({String store_id = ''}) async {
    if (_formsEntreFormKey.currentState!.validate() &&
        passwordConfirmed() &&
        _imageP != null &&
        _imageP!.isNotEmpty &&
        images.isNotEmpty) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;

      final cloudinary1 = CloudinaryPublic('dtdloxmii', 'q2govzgn');
      CloudinaryResponse resimg = await cloudinary1.uploadFile(
        CloudinaryFile.fromFile(_imageP![0].path,
            folder: "ImageP/entrepreneur", publicId: _nameController.text),
      );

      //รูปcathotel
      final cloudinary2 = CloudinaryPublic('dtdloxmii', 'q2govzgn');
      List<String> imageUrls = [];
      var uuid = Uuid();
      String folderPath = "Cathotel/${store_id}/${uuid.v4()}";

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary2.uploadFile(
          CloudinaryFile.fromFile(images[i].path,
              folder: folderPath, publicId: "รูปที่${i + 1}"),
        );
        imageUrls.add(res.secureUrl);
      }
      entreService.signupEntre(
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
        imagesP: resimg.secureUrl,
        user_id: user_id,
        context: context,
        store_id: store_id,
        name: fullnameController.text,
        store_address: store_addressController.text,
        phone: phoneController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        contact: contactController.text,
        province: selectedProvince,
        images: imageUrls,
      );
    } else {
      if (!passwordConfirmed()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('รหัสผ่านไม่ตรงกัน'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (_imageP == null || _imageP!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาเลือกรูปภาพโปรไฟล์'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาเลือกรูปภาพร้านค้า'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
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

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == _cpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    if (mounted) {
      fullnameController.dispose();
      store_addressController.dispose();
      phoneController.dispose();
      descriptionController.dispose();
      priceController.dispose();
      contactController.dispose();
      provinceController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _nameController.dispose();
      _cpasswordController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formsEntreFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LuvCats',
                      style:
                          GoogleFonts.gluten(fontSize: 60.0, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.pets,
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Center(child: Text('เลือกรูปภาพโปรไฟล์')),
                const SizedBox(height: 10),
                _imageP == null || _imageP!.isEmpty
                    ? const CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: Image.file(
                          _imageP![0],
                          fit: BoxFit.cover,
                        ).image,
                        backgroundColor: Colors.white,
                      ),
                Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: const Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    )),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกชื่อ';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ชื่อ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      } else if (RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$')
                          .hasMatch(val)) {
                        return null;
                      } else {
                        return 'ที่อยู่อีเมลไม่ถูกต้อง';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'อีเมล',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(96, 59, 53, 53),
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      } else if (RegExp(r'^[A-Za-z\d]{8,}$').hasMatch(val)) {
                        return null;
                      } else {
                        return 'รหัสผ่านควรมีอักขระ 8 ตัวขึ้นไป';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'รหัสผ่าน',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _cpasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกยืนยันรหัสผ่าน';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ยืนยันรหัสผ่าน',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(child: Text('เลือกรูปภาพร้านค้า')),
                const SizedBox(height: 10),
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
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
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
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        selectImages();
                      },
                      child: const Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    )),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: fullnameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกชื่อ-นามสกุล';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ชื่อ-นามสกุล',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกเบอร์โทร';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'เบอร์โทร',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
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
                      hintText: 'รายละะเอียด',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกราคา';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ราคา',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: contactController,
                    maxLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกช่องทางการติดต่อ';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ช่องทางการติดต่อ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: store_addressController,
                    maxLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกที่อยู่ของร้าน';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'ที่อยู่ของร้าน',
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
                const SizedBox(height: 30),
                CustomButton(
                  text: 'ลงทะเบียน',
                  onTap: formsentre,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
