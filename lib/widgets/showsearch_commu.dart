import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/admin/screens/detailcommu_admin.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class ShowSearchCommu extends StatefulWidget {
  final String query;
  final List<Commu> commulist;
  const ShowSearchCommu({super.key, required this.query, required this.commulist});

  @override
  State<ShowSearchCommu> createState() => _ShowSearchCommuState();
}

class _ShowSearchCommuState extends State<ShowSearchCommu> {
  final CommuServices commuServices = CommuServices();
  final ProfileServices profileService = ProfileServices();
  List<Commu>? commu;
  @override
  void initState() {
    super.initState();
    fetchAllCommu();
  }

  Future<void> fetchAllCommu() async {
    commu = await commuServices.fetchAllCommu(context);

    if (mounted) {
      commu!.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
      setState(() {});
    }
  }

  void delete(String commu) {
    profileService.deleteCommu(context, commu);
  }

  @override
  Widget build(BuildContext context) {
    final filteredCommu = widget.commulist.where((data) {
      return data.title.toLowerCase().contains(widget.query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: filteredCommu.length,
        itemBuilder: (context, index) {
          final commuData = filteredCommu[index];
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final user = userProvider.user.id;
          final userType = userProvider.user.type;

          return InkWell(
            onTap: () {
              if (userType == 'user')
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCommentScreen(commu: commuData),
                  ),
                );
              if (userType == 'admin')
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCommuAdmin(commu: commuData),
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
                              fontWeight: FontWeight.w700, color: Colors.black),
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
                            if (userType == 'user')
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
                            if (userType == 'admin')
                              IconButton(
                                  icon: commuData.likes.contains(user)
                                      ? const Icon(Icons.favorite,
                                          color: Colors.red)
                                      : const Icon(Icons.favorite_border),
                                  onPressed: () async {}),
                            Text(
                              '${commuData.likes.length}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            if (userType == 'user')
                              IconButton(
                                icon: const Icon(Icons.comment),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailCommentScreen(commu: commuData),
                                  ),
                                ),
                              ),
                            if (userType == 'admin')
                              IconButton(
                                  icon: const Icon(Icons.comment),
                                  onPressed: () {}),
                            Text(
                              '${commuData.comments.length}',
                              style: TextStyle(color: Colors.grey),
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
                        if (userProvider.user.type == 'admin')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    delete(commuData.id!);
                                  },
                                  icon: const Icon(Icons.delete_sharp)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
