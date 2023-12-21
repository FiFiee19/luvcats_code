import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/config/utils.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/entrepreneur.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:luvcats_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
// import 'package:luvcat_app/services/auth_services.dart';

class FormsEntre extends StatefulWidget {
  const FormsEntre({super.key});

  @override
  State<FormsEntre> createState() => _FormsEntreState();
}

class _FormsEntreState extends State<FormsEntre> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController user_addressController = TextEditingController();
  final TextEditingController store_addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();

  final EntreService entreService = EntreService();
  List<File> images = [];
  final _formsEntreFormKey = GlobalKey<FormState>();
  List<Entrepreneur>? entre;
  Cathotel? cathotel;

  @override
  void dispose() {
    if (mounted) {
      nameController.dispose();
      user_addressController.dispose();
      store_addressController.dispose();
      phoneController.dispose();
      descriptionController.dispose();
      priceController.dispose();
      contactController.dispose();
      provinceController.dispose();
    }
    super.dispose();
  }

  void formsentre({String store_id = ''}) {
    if (_formsEntreFormKey.currentState!.validate() && images.isNotEmpty) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String user_id = userProvider.user.id;
      entreService.cathotel(
        user_id: user_id,
        context: context,
        store_id: store_id,
        name: nameController.text,
        user_address: user_addressController.text,
        store_address: store_addressController.text,
        phone: phoneController.text,
        description: descriptionController.text,
        price: priceController.text,
        contact: contactController.text,
        province: provinceController.text,
        review_id: '',
        rating: '',
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
          key: _formsEntreFormKey,
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
                  controller: nameController,
                  hintText: 'ชื่อ-นามสกุล',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: user_addressController,
                  hintText: 'ที่อยู่',
                ),
                CustomTextField(
                  controller: store_addressController,
                  hintText: 'ที่อยู่ร้าน',
                ),
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
                  controller: provinceController,
                  hintText: 'จังหวัด',
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Post',
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
