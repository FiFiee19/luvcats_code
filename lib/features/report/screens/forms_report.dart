import 'package:flutter/material.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FormsReport extends StatefulWidget {
  final Commu commu;
  const FormsReport({
    Key? key,
    required this.commu,
  }) : super(key: key);

  @override
  State<FormsReport> createState() => _FormsReportState();
}

class _FormsReportState extends State<FormsReport> {
  final GlobalKey<FormState> reportformKey = GlobalKey<FormState>();
  final CommuServices commuServices = CommuServices();
  final TextEditingController reportController = TextEditingController();

  void report() async {
    if (reportformKey.currentState?.validate() ?? false) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      await commuServices.report(
        user_id: userId,
        context: context,
        message: reportController.text,
        commu_id: widget.commu.id!,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    reportController.dispose();
    super.dispose();
  }

  void _showReportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'รายงาน',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Form(
          key: reportformKey,
          child: TextFormField(
            controller: reportController,
            decoration: const InputDecoration(
              labelText: 'รายละเอียดรายงาน',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกรายละเอียด';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                {Navigator.of(context).pop(), reportController.clear()},
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: report,
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showReportDialog,
      borderRadius: BorderRadius.circular(100),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.report_gmailerrorred),
      ),
    );
  }
}
