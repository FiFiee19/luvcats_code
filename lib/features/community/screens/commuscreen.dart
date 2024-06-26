import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/screens/forms_commu.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:luvcats_app/widgets/search_commu.dart';
import 'package:provider/provider.dart';

class CommuScreen extends StatefulWidget {
  const CommuScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommuScreen> createState() => _CommuScreenState();
}

class _CommuScreenState extends State<CommuScreen> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  String searchtitle = "";
  final ProfileServices profileService = ProfileServices();

  @override
  void initState() {
    super.initState();
    fetchAllCommu();
  }

  //เรียกข้อมูลAllCommuจากcommuServices
  Future<void> fetchAllCommu() async {
    commu = await commuServices.fetchAllCommu(context);

    if (mounted) {
      commu!.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
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

  Widget floatingActionButton() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = userProvider.user.type;

    if (userType == 'user') {
      return FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormsCommu(),
            ),
          );
        },
        shape: const CircleBorder(),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    final user = userProvider.id;
    final userType = userProvider.type;
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormsCommu(),
                ),
              );
            },
            shape: const CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: fetchAllCommu,
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
                    const SizedBox(height: 10),
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
                          if (userType == 'user')
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
                                  "${commuData.likes.length}",
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
                                  "${commuData.comments.length}",
                                  style: const TextStyle(color: Colors.grey),
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
                                  "${commuData.likes.length}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.comment,
                                    ),
                                    onPressed: () {}),
                                Text(
                                  "${commuData.comments.length}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  formatDateTime(commuData.createdAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                if (userType == 'admin')
                                  IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(commuData.id!);
                                      },
                                      icon: const Icon(Icons.delete_sharp)),
                              ],
                            ),
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
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CommuSearchDelegate(commulist: commu ?? []),
            );
          },
        ),
      ]),
      backgroundColor: Colors.grey[200],
      body: bodyContent,
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
