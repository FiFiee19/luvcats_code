import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/screens/forms_commu.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
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
        body: RefreshIndicator(
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
                      builder: (context) =>
                          DetailCommentScreen(commu: commuData),
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
                              style:
                                  Theme.of(context).textTheme.subtitle1!.merge(
                                        const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 10),
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
                    ],
                  ),
                ),
              );
            },
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
    }
  }
}
