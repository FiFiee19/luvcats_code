import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class OneScreen extends StatefulWidget {
  const OneScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OneScreen> createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  final AuthService authService = AuthService();
  final ProfileServices profileService = ProfileServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    Widget bodyContent;
    if (commu == null) {
      bodyContent = const LinearProgressIndicator();
    } else if (commu!.isEmpty) {
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
                    builder: (context) => DetailCommentScreen(commu: commuData),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(commuData.user!.imagesP),
                            radius: 20,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            commuData.user!.username,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (commuData.images.isNotEmpty)
                      CustomCarouselSlider(images: commuData.images),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commuData.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            commuData.description,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 8.0),
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
                                '${commuData.likes.length}',
                                style: const TextStyle(color: Colors.grey),
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
                                '${commuData.comments.length}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 10),
                            child: Text(
                              formatDateTime(commuData.createdAt),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
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
                            if (commuData.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCommu(
                                    commuId: commuData.id!,
                                  ),
                                ),
                              );
                            } 
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _showDeleteDialog(commuData.id!);
                          },
                          icon: const Icon(Icons.delete_sharp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: bodyContent,
    );
  }
}
