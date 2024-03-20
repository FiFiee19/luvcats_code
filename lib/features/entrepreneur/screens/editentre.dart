import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/services/entre_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class EditEntreScreen extends StatefulWidget {
  final String entreId;

  const EditEntreScreen({
    Key? key,
    required this.entreId,
  }) : super(key: key);

  @override
  State<EditEntreScreen> createState() => _EditEntreScreenState();
}

class _EditEntreScreenState extends State<EditEntreScreen> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  bool isLoading = true;

  EntreService entreService = EntreService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();

    // ทำการโหลดข้อมูลโพสต์เดิม
    _loadPostData();
  }

  @override
  void dispose() {
    if (mounted) {
      nameController.dispose();
      addressController.dispose();
      phoneController.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      await entreService.editEntre(
        context,
        widget.entreId,
        nameController.text,
        addressController.text,
        phoneController.text,
      );
    }
  }

  //โหลดข้อมูลผู้ประกอบการ
  Future<void> _loadPostData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final post =
          await entreService.fetchIdEntre(context, userProvider.user.id);
      // นำข้อมูลเดิมมาใส่ใน TextEditingController
      nameController.text = post.name;
      addressController.text = post.store_address;
      phoneController.text = post.phone;
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
        title: const Text('แก้ไขข้อมูลผู้ประกอบการ'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ-นามสกุล';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'ที่อยู่ของร้าน',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกที่อยู่ของร้าน';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทร',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเบอร์โทร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
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
