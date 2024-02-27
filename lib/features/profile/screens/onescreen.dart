import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/screens/editcommu.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:provider/provider.dart';

class OneScreen extends StatefulWidget {
  const OneScreen({super.key});

  @override
  State<OneScreen> createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchCommuProfile();
  }

  Future<void> fetchCommuProfile() async {
    commu = await profileService.fetchCommuProfile(context);

    if (mounted) {
      commu!.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
    if (commu == null) {
      return const Loader(); // แสดงตัวโหลดถ้า commu ยังไม่ได้ถูกเรียก
    } else if (commu!.isEmpty) {
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
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: fetchCommuProfile,
          child: ListView.builder(
            itemCount: commu!.length,
            itemBuilder: (context, index) {
              final commuData = commu![index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailCommentScreen(commu: commuData),
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
                      // User info and post metadata, always shown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(commuData.user!.imagesP),
                              radius: 20,
                            ),
                            SizedBox(width: 20),
                            Text(
                              commuData.user!.username,
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Conditional rendering based on whether there are images
                      if (commuData.images.isNotEmpty)
                        CustomCarouselSlider(images: commuData.images),

                      // Post title and description, always shown
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commuData.title,
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              commuData.description,
                              style:
                                  Theme.of(context).textTheme.subtitle2!.merge(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade500),
                                      ),
                            ),
                            const SizedBox(height: 8.0),
                            // Likes, comments, and interactions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LikeAnimation(
                                  isAnimating: commuData.likes.contains(user),
                                  smallLike: true,
                                  child: IconButton(
                                    icon: commuData.likes.contains(user)
                                        ? const Icon(Icons.favorite,
                                            color: Colors.red)
                                        : const Icon(Icons.favorite_border),
                                    onPressed: () async {
                                      setState(() {
                                        if (commuData.likes.contains(user)) {
                                          commuData.likes.remove(user);
                                        } else {
                                          commuData.likes.add(user);
                                        }
                                      });
                                      await commuServices.likesCommu(
                                          context, commuData.id!);
                                    },
                                  ),
                                ),
                                Text(
                                  '${commuData.likes.length}', // Display number of likes
                                  style: TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.comment),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailCommentScreen(commu: commuData),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${commuData.comments.length}', // Display number of comments
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 10),
                              child: Text(
                                formatDateTime(commuData.createdAt),
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
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Make sure 'commuData.id' is non-nullable before you pass it
                              if (commuData.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCommu(
                                      commuId: commuData.id!,
                                    ),
                                  ),
                                );
                              } else {
                                // Handle the case where 'commuData.id' is null
                              }
                            },
                            icon: Icon(Icons.edit),
                          ),
                          
                          IconButton(
                            onPressed: () {
                            
                                          profileService.deleteCatCommu(
                                              context, commuData.id!);
                             
                            },
                            icon: Icon(Icons.delete_sharp),
                          )
                        ],
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
