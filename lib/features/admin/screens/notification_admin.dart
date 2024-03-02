import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/admin/screens/detailcommu_admin.dart';

import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/report.dart';

class NotificationAdmin extends StatefulWidget {
  const NotificationAdmin({super.key});

  @override
  State<NotificationAdmin> createState() => _NotificationAdminState();
}

class _NotificationAdminState extends State<NotificationAdmin> {
  List<Report>? reports;
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  final ProfileServices profileService = ProfileServices();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  //เรียกข้อมูลAllCommuจากcommuServices
  Future<void> fetchReport() async {
    reports = await commuServices.fetchAllReport(context);

    if (mounted) {
      setState(() {});
    }
  }

  //ลบCommu
  void delete(String commu) {
    profileService.deleteCommu(context, commu);
  }

  @override
  Widget build(BuildContext context) {
    if (reports == null) {
      return Center(child: const CircularProgressIndicator());
    } else if (reports!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'ไม่มีการรายงาน',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchReport,
          child: ListView.builder(
            itemCount: reports!.length,
            itemBuilder: (context, index) {
              final reportData = reports![index];

              return InkWell(
                onTap: () async {
                  final commuId =
                      reportData.commu_id?.id; // Get the ID from commu_id
                  if (commuId != null) {
                    final commu = await commuServices.fetchIdCommu(
                        context, commuId); // Fetch the Commu object
                    if (commu != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCommuAdmin(commu: commu),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load Commu data'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                      reportData.user!.imagesP,
                                    ),
                                    radius: 15),
                                SizedBox(width: 10),
                                Text(
                                  reportData.user!.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, bottom: 10),
                              child: Row(
                                children: [
                                  Text('รายงานโพสต์ว่า'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('"'),
                                  Text(
                                    reportData.message.length > 10
                                        ? "${reportData.message.substring(0, 10)}..."
                                        : reportData.message,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text('"'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, bottom: 10),
                                  child: Text(
                                    formatDateTime(reportData.createdAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .merge(
                                          TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    commuServices.deleteReport(
                                        context, reportData.id!);
                                  },
                                  icon: Icon(Icons.delete_sharp),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
