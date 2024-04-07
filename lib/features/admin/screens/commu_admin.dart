import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/admin/screens/detailcommu_admin.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/search_commu.dart';
import 'package:provider/provider.dart';

class CommuAdmin extends StatefulWidget {
  const CommuAdmin({super.key});

  @override
  State<CommuAdmin> createState() => _CommuAdminState();
}

class _CommuAdminState extends State<CommuAdmin> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  final ProfileServices profileService = ProfileServices();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchAllCommu();
  }

  //เรียกข้อมูลAllCommuจากcommuServices
  Future<void> fetchAllCommu() async {
    commu = await commuServices.fetchAllCommu(context);

    if (mounted) {
      commu!.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
      setState(() {});
    }
  }

  //ลบCommu
  void _showDeleteDialog(String commu) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'ลบโพสต์',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              await profileService.deleteCommu(context, commu);

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
    if (commu == null) {
      return Center(child: const CircularProgressIndicator());
    } else if (commu!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'ไม่มีโพสต์',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CommuSearchDelegate(commulist: commu ?? []),
              );
            },
          ),
        ]),
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchAllCommu,
          child: ListView.builder(
            itemCount: commu!.length,
            itemBuilder: (context, index) {
              final commuData = commu![index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailCommuAdmin(commu: commuData),
                    ),
                  );
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                commuData.user!.imagesP,
                              ),
                              radius: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${commuData.user!.username}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 96.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (commuData.images.isNotEmpty)
                        CustomCarouselSlider(images: commuData.images),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${commuData.title}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${commuData.description}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: commuData.likes.contains(user)
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                          ),
                                    onPressed: () async {},
                                  ),
                                  Text(
                                    '${commuData.likes.length}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.comment,
                                      ),
                                      onPressed: () {}),
                                  Text(
                                    '${commuData.comments.length}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(commuData.id!);
                                      },
                                      icon: Icon(Icons.delete_sharp)),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 10),
                                child: Text(
                                  formatDateTime(commuData.createdAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ]),
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
