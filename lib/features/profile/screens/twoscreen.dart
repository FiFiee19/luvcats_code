import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/services/cat_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:provider/provider.dart';

class TwoScreen extends StatefulWidget {
  const TwoScreen({super.key});

  @override
  State<TwoScreen> createState() => _TwoScreenState();
}

class _TwoScreenState extends State<TwoScreen> {
  List<Cat>? cat;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    cat = await profileService.fetchStrayCatProfile(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
    if (cat == null) {
      return const Loader(); // แสดงตัวโหลดถ้า commu ยังไม่ได้ถูกเรียก
    } else if (cat!.isEmpty) {
      // แสดงข้อความ No Post ถ้าไม่มีโพสต์
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'No Post',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchProfile,
          child: ListView.builder(
            itemCount: cat!.length,
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 1,
            //   crossAxisSpacing: 12.0,
            //   mainAxisSpacing: 12.0,
            //   mainAxisExtent: 450,
            // ),
            itemBuilder: (context, index) {
              final catData = cat![index];

              return Container(
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
                          onTap: () =>
                              buttonCarouselController.animateToPage(entry.key),
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
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 220),
                            child: IconButton(
                                onPressed: () {
                                  profileService.deleteCat(
                                      context, catData.id!);
                                },
                                icon: Icon(Icons.delete_sharp)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${catData.breed}",
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${catData.gender}",
                              style:
                                  Theme.of(context).textTheme.subtitle2!.merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "${catData.province}",
                              style:
                                  Theme.of(context).textTheme.subtitle2!.merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${catData.description}",
                              style:
                                  Theme.of(context).textTheme.subtitle2!.merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
