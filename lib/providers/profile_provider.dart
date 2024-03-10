import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  List<Commu> _commuList = [];
  List<Straycat> _straycatList = [];

  List<Commu> get commuList => _commuList;
  List<Straycat> get straycatList => _straycatList;

  final UserProvider _userProvider;
  ProfileProvider(this._userProvider);
  
  // Fetch Community Posts by User ID
  Future<void> fetchCommuProfile() async {
    final userId = _userProvider.user.id;
    try {
      http.Response res = await http.get(
        Uri.parse('$url/getCommu/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': _userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        _commuList = (jsonDecode(res.body) as List)
            .map((data) => Commu.fromJson(jsonEncode(data)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle errors
      throw Exception('Error fetching community posts: $e');
    }
  }

  Future<List<Commu>> fetchCommuId(BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<Commu> commuList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getCommu/id/$user_id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          commuList.add(
            Commu.fromJson(
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
    return commuList;
  }

  //ดึงข้อมูลStrayCatจากuser_idของผู้ใช้งาน
  Future<List<Straycat>> fetchStrayCatProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
    List<Straycat> straycatList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat/$userId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          straycatList.add(
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
    return straycatList;
  }

  //ดึงข้อมูลStrayCatจากuser_idที่กำหนด
  Future<List<Straycat>> fetchStrayCatId(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<Straycat> straycatList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$url/getStrayCat/id/$user_id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          straycatList.add(
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
    return straycatList;
  }

  //ดึงข้อมูลUser
  Future<User> fetchIdUser(BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final user_id = userProvider.user.id;
    try {
      http.Response res = await http.get(
        Uri.parse('$url/profile/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map<String, dynamic>) {
          return User.fromMap(data);
        } else {
          throw Exception('Data format is not correct: Expected a Map');
        }
      } else {
        throw Exception('Failed to load data: Status ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  //ลบcommu
  Future<void> deleteCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getCommu/delete/$commuId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'commuId': commuId,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
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

  //ลบStrayCat
  Future<void> deleteStrayCat(BuildContext context, String straycatId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getStrayCat/delete/$straycatId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'straycatId': straycatId,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
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

  //แก้ไขรหัสผ่าน
  Future<void> editPassword(
    BuildContext context,
    String password,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user_id = userProvider.user.id;
    // อัปโหลดรูปภาพใหม่และรับ URL
    try {
      final res = await http.put(
        Uri.parse('$url/editP/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'password': password,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('แก้ไขรหัสผ่านสำเร็จ!')),
        );
        Navigator.pop(context);
        print(res.body);
      }
    } catch (e) {
      print('Error updating password: $e');
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

  //แก้ไขข้อมูลส่วนตัวของuser
  Future<User?> editUser(
      BuildContext context, String username, File? image) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    String? imageUrl = userProvider.user.imagesP;

    try {
      if (image != null) {
        final cloudinary = CloudinaryPublic('dtdloxmii', 'q2govzgn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: 'a'),
        );
        imageUrl = response.secureUrl;
      }

      final response = await http.put(
        Uri.parse('$url/editU/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'username': username,
          'imagesP': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic>) {
          final updatedUser = User.fromMap(responseData);
          userProvider.setUserFromModel(updatedUser);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('แก้ไขสำเร็จ!')),
          );
          // You can also choose to navigate back
          // Navigator.pop(context);
          return updatedUser;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update the profile: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
    return null;
  }

  //ค้นหาuserจากชื่อ
  Future<List<User>?> searchName(BuildContext context, String username) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$url/searchU/$username'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        final List<User> users =
            dataList.map((data) => User.fromMap(data)).toList();
        return users;
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
      return null;
    }
  }

  //ค้นหาร้านค้าจากชื่อ
  Future<List<User>?> searchEntre(BuildContext context, String username) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$url/searchE/$username'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        final List<User> users =
            dataList.map((data) => User.fromMap(data)).toList();
        return users;
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
      return null;
    }
  }

  
}
