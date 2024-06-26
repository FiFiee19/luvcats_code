import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CatServices {
  //โพสต์แมวจร
  void postcat({
    required BuildContext context,
    required String user_id,
    required String breed,
    required String description,
    required String gender,
    required String province,
    required List<String> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Straycat cat = Straycat(
        user_id: user_id,
        breed: breed,
        gender: gender,
        province: province,
        description: description,
        images: images,
      );

      http.Response res = await http.post(
        Uri.parse('$url/postStrayCat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: cat.toJson(),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('โพสต์สำเร็จ!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }

  //ดึงข้อมูลแมวจรทั้งหมด
  Future<List<Straycat>> fetchAllCats(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Straycat> catList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          catList.add(
            Straycat.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
    return catList;
  }

  //ดึงข้อมูลแมวจรจากidที่กำหนด
  Future<Straycat> fetchIdStraycat(
      BuildContext context, String straycatId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getStrayCat/stray/$straycatId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Straycat.fromMap(data);
        
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  //อัพเดตการได้บ้านของแมวจร
  Future<void> updateCatStatus(
      BuildContext context, String straycatId, String newStatus) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$url/updateStatus/$straycatId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'status': newStatus,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('อัปเดตสำเร็จ!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }

  //แก้ไขโพสต์แมวจร
  Future<void> editPostCat(
    BuildContext context,
    String starycatsId,
    String breed,
    String gender,
    String province,
    String description,
    List<File> images, 
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    List<String> imageUrls = []; 
    var uuid = Uuid();
    String folderPath = "Straycat/${user_id}/edit/${uuid.v4()}";
    
    if (images != null && images.isNotEmpty) {
      
      try {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: folderPath, publicId: 'รูปที่${i + 1}'),
          );
          imageUrls.add(res.secureUrl);
        }
      } catch (e) {
        print('Error uploading images: $e');
      }
    } else {
      // ถ้าไม่มีการเลือกรูปภาพใหม่ใช้รูปภาพเดิมที่เก็บไว้ในฐานข้อมูล
      final post = await fetchIdStraycat(context, starycatsId);
      imageUrls = post.images;
    }

    try {
      final res = await http.put(
        Uri.parse('$url/getStrayCat/edit/$starycatsId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'breed': breed,
          'gender': gender,
          'province': province,
          'description': description,
          'images': imageUrls, 
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('แก้ไขสำเร็จ!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }
}
