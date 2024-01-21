import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class DetailCommuScreen extends StatefulWidget {
  final Commu commu;
  const DetailCommuScreen({
    Key? key,
    required this.commu,
  }) : super(key: key);

  @override
  State<DetailCommuScreen> createState() => _DetailCommuScreenState();
}

class _DetailCommuScreenState extends State<DetailCommuScreen> {
  final CommuServices commuServices = CommuServices();
  var selectedItem = '';
  bool isLoading = true;
  List<Comment> comments = []; // แก้ไขเป็น List<Comment>

  @override
  void initState() {
    super.initState();
    loadComments();

    // แก้ไขการเรียกใช้ฟังก์ชัน
  }

  Future<void> loadComments() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.commu.id != null) {
        comments = await commuServices.fetchComment(context, widget.commu.id!);
        // print(comments);
      } else {
        print("Post ID is null");
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user.id;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 220),
                child: ReportScreen()),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    widget.commu.user!.images,
                  ),
                  radius: 20,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${widget.commu.user!.username}",
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
          CustomCarouselSlider(
            images: widget.commu.images,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.commu.title,
                        style: Theme.of(context).textTheme.subtitle1!.merge(
                            const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.commu.description,
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade500,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LikeAnimation(
                    isAnimating: widget.commu.likes.contains(user),
                    smallLike: true,
                    child: IconButton(
                      icon: widget.commu.likes.contains(user)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                      onPressed: () async {
                        setState(() {
                          if (widget.commu.likes.contains(user)) {
                            widget.commu.likes.remove(user);
                          } else {
                            widget.commu.likes.add(user);
                          }
                        });
                        await commuServices.likesCommu(
                            context, widget.commu.id!);
                      },
                    ),
                  ),
                  Text(
                    '${widget.commu.likes.length}', // แสดงจำนวน likes
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.commu.comments.length} ความคิดเห็น",
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // ให้เนื้อหาชิดซ้าย
                children: comments
                    .map(
                      (comment) => Align(
                        alignment: Alignment
                            .centerLeft, // ใช้ Align เพื่อจัดให้เนื้อหาชิดซ้าย
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        comment.user!.images,
                                      ),
                                      radius: 15),
                                  SizedBox(width: 10),
                                  Text(
                                    comment.user?.username ?? 'Anonymous',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, bottom: 10),
                                child: Text(
                                  comment.message,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, bottom: 10),
                                child: Text(
                                  comment.createdAt != null
                                      ? DateFormat('yyyy-MM-dd – kk:mm').format(
                                          DateTime.parse(comment.createdAt!))
                                      : 'ไม่ทราบวันที่',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
