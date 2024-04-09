import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/screens/editstraycats.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';

class TwoScreen extends StatefulWidget {
  const TwoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TwoScreen> createState() => _TwoScreenState();
}

class _TwoScreenState extends State<TwoScreen> {
  List<Straycat>? straycats;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();
  Map<String, bool> statusCats = {};

  int _current = 0;

  @override
  void initState() {
    super.initState();
    fetchStraycatsProfile();
  }

  Future<void> fetchStraycatsProfile() async {
    straycats = await profileService.fetchStrayCatProfile(context);
    if (straycats != null) {
      final newstatusCats = <String, bool>{};
      for (var c in straycats!) {
        newstatusCats[c.id!] = c.status == 'yes';
      }
      if (mounted) {
        straycats!.sort((a, b) => DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!)));
        setState(() {
          statusCats = newstatusCats;
        });
      }
    }
  }

  void _showDeleteDialog(String straycat) {
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
              await profileService.deleteStrayCat(context, straycat);

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
    if (straycats == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (straycats!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: Text(
            'ไม่มีโพสต์',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchStraycatsProfile,
          child: ListView.builder(
            itemCount: straycats!.length,
            itemBuilder: (context, index) {
              final catData = straycats![index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailStraycatScreen(straycat: catData),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCarouselSlider(images: catData.images),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                catData.user!.imagesP,
                              ),
                              radius: 20,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              catData.user!.username,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "สายพันธุ์:  " + catData.breed,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "เพศ:  " + catData.gender,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "จังหวัด:  " + catData.province,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ข้อมูลเพิ่มเติม: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, bottom: 20, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        catData.description,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  formatDateTime(catData.createdAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (catData.id != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditStraycats(
                                              starycatsId: catData.id!,
                                            ),
                                          ),
                                        );
                                      } else {}
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(catData.id!);
                                    },
                                    icon: const Icon(Icons.delete_sharp),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              if (!(statusCats[catData.id] ?? false))
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        catServices.updateCatStatus(
                                      context,
                                      '${catData.id}',
                                      'yes',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(40, 40),
                                        backgroundColor: Colors.red),
                                    child: const Text(
                                      'ได้บ้านแล้ว',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              if (statusCats[catData.id] ?? false)
                                const Center(
                                  child: Text('ได้บ้านแล้ว',
                                      style: TextStyle(color: Colors.red)),
                                ),
                            ]),
                      ),
                     const SizedBox(
                        height: 20,
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
