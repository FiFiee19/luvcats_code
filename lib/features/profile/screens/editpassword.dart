import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  ProfileServices profileServices = ProfileServices();

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (globalFormKey.currentState!.validate()) {
      
      await profileServices.editPassword(context, newPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Password'),
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
                  controller: newPasswordController,
                  obscureText: true, // Hides the text being edited
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true, // Hides the text being edited
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                  ),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Confirmation password does not match the new password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
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
