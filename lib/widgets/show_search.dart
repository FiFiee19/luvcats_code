import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class ShowSearcher extends StatefulWidget {
   final String query;
   final List<Commu> commulist;
  const ShowSearcher({super.key, required this.query,required this.commulist});

  @override
  State<ShowSearcher> createState() => _ShowSearchState();
}

class _ShowSearchState extends State<ShowSearcher> {
  final CommuServices commuServices =CommuServices();
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
      commu!.sort((a, b) => DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
      setState(() {});
    }
  }
  void delete(String commu) {
    profileService.deleteCatCommu(context, commu);
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
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final user = userProvider.user.id;
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
                          backgroundImage: NetworkImage(commuData.user!.imagesP),
                          radius: 20,
                        ),
                        SizedBox(width: 20),
                        Text(
                          commuData.user!.username,
                          style: Theme.of(context).textTheme.subtitle1!.merge(
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
                          style: Theme.of(context).textTheme.subtitle1!.merge(
                                const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          commuData.description,
                          style: Theme.of(context).textTheme.subtitle2!.merge(
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
                          padding: const EdgeInsets.only(left: 5, bottom: 10),
                          child: Text(
                            formatDateTime(commuData.createdAt),
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                          ),
                        ),
                        if(userProvider.user.type == 'admin')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  delete(commuData.id!);
                                },
                                icon: Icon(Icons.delete_sharp)),
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
