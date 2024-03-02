import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/loader.dart';
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

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    fetchStraycatsId();
  }

  Future<void> fetchStraycatsId() async {
    straycats = await profileService.fetchStrayCatId(context,widget.user.id);
    if (straycats != null) {
      // กรองเฉพาะ cats ที่มีสถานะเป็น "no"
      straycats = straycats!.where((cat) => cat.status == 'no').toList();
    }
    
      if (mounted) {
      setState(() {});
    }
    
  }
  //ลบStrayCat
  void delete(String straycat) {
    profileService.deleteStrayCat(context, straycat);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = userProvider.user.type;
    if (straycats == null) {
      return Center(child: const CircularProgressIndicator()); // แสดงตัวโหลดถ้า commu ยังไม่ได้ถูกเรียก
    } else if (straycats!.isEmpty) {
      // แสดงข้อความ No Post ถ้าไม่มีโพสต์
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
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchStraycatsId,
          child: ListView.builder(
            itemCount: straycats!.length,
            itemBuilder: (context, index) {
              final catData = straycats![index];

              return InkWell(
                onTap: () {
                  // ทำสิ่งที่คุณต้องการเมื่อกดที่ Container
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailStraycatScreen(straycat: catData),
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
                      CarouselSlider(
                        items: catData.images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.network(
                                i,
                                fit: BoxFit.contain,
                                height: 300,
                              ),
                            );
                          },
                        ).toList(),
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index; // อัปเดตตำแหน่งสไลด์ปัจจุบัน
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: catData.images.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => buttonCarouselController
                                .animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == entry.key
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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
                                catData.user!.imagesP,
                              ),
                              radius: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${catData.user!.username}",
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade900,
                                            ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade900,
                                            ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade900,
                                            ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade900,
                                            ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade900,
                                              ),
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
                                  ),Spacer(),
                                  if(userType == 'admin')
                              IconButton(
                                  onPressed: () {
                                    delete(catData.id!);
                                  },
                                  icon: Icon(Icons.delete_sharp)),
                              
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
        ),
      );
    }
  }
}
