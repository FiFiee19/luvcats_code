import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<List<File>> pickImagesFiles(bool multi) async {
  List<File> images = [];

  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: multi,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future pickImageGallery() async {
  File? _image;
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return _image;
}
