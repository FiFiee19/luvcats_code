import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:provider/provider.dart';

class TwoSreenOfUser extends StatefulWidget {
  final User user;
  const TwoSreenOfUser({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<TwoSreenOfUser> createState() => _TwoSreenOfUserState();
}

class _TwoSreenOfUserState extends State<TwoSreenOfUser> {
  List<Straycat>? straycats;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();
  Map<String, bool> statusCats = {};

  @override
  void initState() {
    super.initState();
    fetchStraycatsId();
  }

  Future<void> fetchStraycatsId() async {
    straycats = await profileService.fetchStrayCatId(context, widget.user.id);
    if (straycats != null) {
      straycats = straycats!.where((cat) => cat.status == 'no').toList();
    }

    if (mounted) {
      setState(() {});
    }
  }
  //ลบStrayCat

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = userProvider.user.type;
    Widget bodyContent;
    if (straycats == null) {
      bodyContent = const LinearProgressIndicator();
    } else if (straycats!.isEmpty) {
      bodyContent = Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: Text(
            'ไม่มีโพสต์',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: fetchStraycatsId,
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                            Row(
                              children: [
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
                                const Spacer(),
                                if (userType == 'admin')
                                  IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(catData.id!);
                                      },
                                      icon: const Icon(Icons.delete_sharp)),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return Scaffold(backgroundColor: Colors.grey[200], body: bodyContent);
  }
}
