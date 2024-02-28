import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';


class CommuProvider with ChangeNotifier {
  
  List<Commu> _commus = [];

  List<Commu> get commus => _commus;

  void setCommus(List<Commu> commus) {
    _commus = commus;
    notifyListeners();
  }
  void updateLikes(BuildContext context,String commuId, bool isLiked) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
  int index = _commus.indexWhere((commu) => commu.id == commuId);
  if (index != -1) {
    if (isLiked) {
      _commus[index].likes.add(userProvider.user.id); // สมมติว่าเรามี ID ของผู้ใช้
    } else {
      _commus[index].likes.remove(userProvider.user.id);
    }
    notifyListeners();
  }
}
void addLike(BuildContext context,String commuId, String userId) {
  // หา commu และเพิ่ม userId ลงใน likes
  notifyListeners(); // อัปเดต listeners
}

void removeLike(String commuId, String userId) {
  // หา commu และลบ userId ออกจาก likes
  notifyListeners(); // อัปเดต listeners
}



Future<void> likesCommu(BuildContext context, String commuId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      http.Response res =
          await http.put(Uri.parse('$url/likesCommu/$commuId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authtoken': userProvider.user.token,
      });

      if (res.statusCode == 200) {
        print('Request successful!');
        print(res.body);
      } else {
        print('Request failed with status: ${res.statusCode}.');
        print(res.body);
      }
      notifyListeners();
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
