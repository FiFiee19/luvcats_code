import 'package:flutter/material.dart';
import 'package:luvcats_app/features/admin/screens/detailcommu_admin.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
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
  final ProfileServices profileService = ProfileServices();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchCommuId();
  }

  Future<void> fetchCommuId() async {
    commu = await profileService.fetchCommuId(context, widget.user.id);
    if (mounted) {
      setState(() {});
    }
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user.id;
    final userType = userProvider.user.type;
    if (commu == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (commu!.isEmpty) {
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
                      builder: (context) => DetailCommuAdmin(commu: commuData),
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
                                commuData.user!.imagesP,
                              ),
                              radius: 20,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              commuData.user!.username,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (commuData.images.isNotEmpty)
                        CustomCarouselSlider(
                          images: commuData.images,
                        ),
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
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                commuData.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              if (userType == 'user')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    LikeAnimation(
                                      isAnimating:
                                          commuData.likes.contains(widget.user),
                                      smallLike: true,
                                      child: IconButton(
                                        icon: commuData.likes
                                                .contains(widget.user)
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
                                              commuData.likes
                                                  .remove(widget.user);
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
                                      '${commuData.likes.length}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.comment,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailCommentScreen(
                                            commu: commuData,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${commuData.comments.length}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              if (userType == 'admin')
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
                              if (userType == 'admin')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _showDeleteDialog(commuData.id!);
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
        ),
      );
    }
  }
}
