import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:provider/provider.dart';

class OneScreenOfUser extends StatefulWidget {
  final User user;
  const OneScreenOfUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<OneScreenOfUser> createState() => _OneScreenOfUserState();
}

class _OneScreenOfUserState extends State<OneScreenOfUser> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  // final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchCommuId();
    print(commu);
    print("Fetching data for user ID: ${widget.user.id}");
    final userss = Provider.of<UserProvider>(context, listen: false).user.id;
    print(userss);
  }

  Future<void> fetchCommuId() async {
    commu = await profileService.fetchCommuId(context, widget.user.id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (commu == null) {
      return Center(child: const CircularProgressIndicator());
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
          onRefresh: fetchCommuId,
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
                      SizedBox(
                        height: 20,
                      ),
                      CarouselSlider(
                        items: commuData.images.map(
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
                              _current = index; 
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: commuData.images.asMap().entries.map((entry) {
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
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${commuData.title}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .merge(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  LikeAnimation(
                                    isAnimating:
                                        commuData.likes.contains(widget.user),
                                    smallLike: true,
                                    child: IconButton(
                                      icon:
                                          commuData.likes.contains(widget.user)
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_border,
                                                ),
                                      onPressed: () async {
                                        setState(() {
                                          if (commuData.likes
                                              .contains(widget.user)) {
                                            commuData.likes.remove(widget.user);
                                          } else {
                                            commuData.likes.add(widget.user);
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
                                        builder: (context) =>
                                            DetailCommentScreen(
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
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
