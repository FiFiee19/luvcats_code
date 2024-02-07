import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/community/screens/detail_commu.dart';
import 'package:luvcats_app/features/community/screens/postcommu.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:provider/provider.dart';

class CommuScreen extends StatefulWidget {
  const CommuScreen({super.key});

  @override
  State<CommuScreen> createState() => _CommuScreenState();
}

class _CommuScreenState extends State<CommuScreen> {
  List<Commu>? commu;
  Commu? commuu;
  final CommuServices commuServices = CommuServices();
  final AuthService authService = AuthService();
  CarouselController buttonCarouselController = CarouselController();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchAllCommu();
  }

  fetchAllCommu() async {
    commu = await commuServices.fetchAllCommu(context);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getData() async {
    setState(() {
      fetchAllCommu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
    if (commu == null) {
      return const Loader(); 
    } else if (commu!.isEmpty) {
      
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
          onRefresh: _getData,
          child: GridView.builder(
            itemCount: commu!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              mainAxisExtent: 450,
            ),
            itemBuilder: (context, index) {
              final commuData = commu![index];

              return Container(
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
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                          ),
                          const SizedBox(
                            width: 96.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomCarouselSlider(images: commuData.images),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${commuData.title}",
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${commuData.description}",
                              style:
                                  Theme.of(context).textTheme.subtitle2!.merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LikeAnimation(
                                  isAnimating: commuData.likes.contains(user),
                                  smallLike: true,
                                  child: IconButton(
                                    icon: commuData.likes.contains(user)
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                          ),
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
                                  '${commuData.likes.length}', // แสดงจำนวน likes
                                  style: TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.comment,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailCommuScreen(
                                        commu: commuData,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${commuData.comments.length}', // แสดงจำนวน likes
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCommu(),
                ),
              );
            },
            shape: const CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    }
  }
}
