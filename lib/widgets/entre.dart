import 'package:flutter/material.dart';
import 'package:luvcats_app/features/entrepreneur/screens/editentre.dart';
import 'package:luvcats_app/models/entrepreneur.dart';

class EntrePerson extends StatefulWidget {
  final Entrepreneur entre; // เพิ่มตัวแปรนี้

  const EntrePerson({
    Key? key,
    required this.entre, // เพิ่มตัวแปรนี้
  }) : super(key: key);

  @override
  State<EntrePerson> createState() => _EntrePersonState();
}

class _EntrePersonState extends State<EntrePerson> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
            leading: Icon(Icons.person),
            title: const Text('ข้อมูลผู้ประกอบการ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditEntreScreen(entreId: widget.entre.id)),
              );
            },
          );
  }
}