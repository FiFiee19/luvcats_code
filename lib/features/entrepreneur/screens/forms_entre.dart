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
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:luvcats_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class FormsEntre extends StatefulWidget {
  const FormsEntre({super.key});

  @override
  State<FormsEntre> createState() => _FormsEntreState();
}

class _FormsEntreState extends State<FormsEntre> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController user_addressController = TextEditingController();
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
  List<Entrepreneur>? entre;
  Cathotel? cathotel;
  File? _imageP;
  String selectedProvince = 'กรุงเทพมหานคร';

  void _pickImage() async {
    var res = await pickImage();
    if (!mounted) return;
    setState(() {
      _imageP = res;
    });
  }

  void formsentre({String store_id = ''}) async {
    if (_formsEntreFormKey.currentState!.validate() &&
        passwordConfirmed() &&
        _imageP != null &&
        images.isNotEmpty) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;
      final cloudinary = CloudinaryPublic('denfgaxvg', 'uszbstnu');
      CloudinaryResponse resimg = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_imageP!.path, folder: "a"),
      );
      print(resimg.secureUrl);
      entreService.cathotel(
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
        imagesP: resimg.secureUrl,
        user_id: user_id,
        context: context,
        store_id: store_id,
        name: fullnameController.text,
        user_address: user_addressController.text,
        store_address: store_addressController.text,
        phone: phoneController.text,
        description: descriptionController.text,
        price: priceController.text,
        contact: contactController.text,
        province: selectedProvince,
        images: images,
      );
    } else {
      if (!passwordConfirmed()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('รหัสผ่านไม่ตรงกัน'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (_imageP == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('กรุณาเลือกรูปภาพ'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }

      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('กรุณาเลือกรูปภาพ'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(30),
          ),
        );
      }
    }
  }

  void selectImages() async {
    var res = await pickImages();
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
      user_addressController.dispose();
      store_addressController.dispose();
      phoneController.dispose();
      descriptionController.dispose();
      priceController.dispose();
      contactController.dispose();
      provinceController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _nameController.dispose();
    }
    super.dispose();
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
          key: _formsEntreFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(child: Text('เลือกรูปภาพโปรไฟล์')),
                const SizedBox(height: 10),
                _imageP == null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: Image.file(
                          _imageP!,
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
                      child: Icon(
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
                          borderSide: BorderSide(
                            color: Colors.black38,
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
                          borderSide: BorderSide(
                            color: Colors.black38,
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
                          borderSide: BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                          borderSide: BorderSide(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(child: Text('เลือกรูปภาพร้านค้า')),
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
                  controller: fullnameController,
                  hintText: 'ชื่อ-นามสกุล',
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'เบอร์โทร',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'รายละเอียด',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'ราคา',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: contactController,
                  hintText: 'ช่องทางการติดต่อ',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: user_addressController,
                  hintText: 'ที่อยู่',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: store_addressController,
                  hintText: 'ที่อยู่ของร้าน',
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
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'ลงทะเบียน',
                  onTap: formsentre,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
