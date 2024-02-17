import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  void _showReportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'รายงาน',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            // ตั้งค่าสำหรับ TextFormField
            // ตัวอย่างเช่น: validator, onSaved, ฯลฯ
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // โค้ดเพื่อจัดการเมื่อแบบฟอร์มถูกต้อง
              }
            },
            child: const Text('ยืนยัน'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showReportDialog, // เรียกใช้ฟังก์ชันเมื่อมีการกดไอคอน
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // ปรับขนาด padding ตามที่คุณต้องการ
        child: Icon(Icons.report_gmailerrorred),
      ),
    );
  }
}
