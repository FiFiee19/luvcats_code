import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'บันทึกค่าใช้จ่าย',style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
      body: Column(children: [
        Row(
          children: [
            Padding(padding:  EdgeInsets.all(20),
            child: Text("รวมค่าใช้จ่ายรายเดือน"),),
            SizedBox(width: 80,),
            ElevatedButton(onPressed: (){}, child: Text("เพิ่มค่าใช้จ่าย"))
          ],
        )
      ],),
    );
  }
}