import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/screens/signin.dart';
import 'package:luvcats_app/features/entrepreneur/screens/forms_entre.dart';

class AlertType extends StatelessWidget {
  const AlertType({super.key});

  @override
  Widget build(BuildContext context) {
    // เรียกใช้ Future.microtask เพื่อแสดง AlertDialog หลังจากวิดเจ็ตสร้างเสร็จ
    Future.microtask(() => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('เลือกประเภทของคุณ'),
            content: const Text('คุณต้องการเป็นสมาชิกหรือผู้ประกอบการ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'สมาชิก'),
                child: const Text('สมาชิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'ผู้ประกอบการ'),
                child: const Text('ผู้ประกอบการ'),
              ),
            ],
          ),
        )).then((result) {
      if (result == 'สมาชิก') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SigninScreen()),
        );
      } else if (result == 'ผู้ประกอบการ') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FormsEntre()),
        );
      }
    });

    return Container(); // หรือวิดเจ็ตอื่นที่เหมาะสม
  }
}
