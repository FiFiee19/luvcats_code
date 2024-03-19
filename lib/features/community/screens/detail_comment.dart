import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
// import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class DetailCommentScreen extends StatefulWidget {
  final Commu commu;
  const DetailCommentScreen({
    Key? key,
    required this.commu,
  }) : super(key: key);

  @override
  State<DetailCommentScreen> createState() => _DetailCommentScreenState();
}

class _DetailCommentScreenState extends State<DetailCommentScreen> {
  final TextEditingController commentController = TextEditingController();
  final CommuServices commuServices = CommuServices();
  bool isLoading = true;
  List<Comment> comments = [];
  final ProfileServices profileService = ProfileServices();

  final _sendCommentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadComments();
    widget.commu.comments;
  }

  //เรียกข้อมูลCommentsจากcommuServices
  Future<void> loadComments() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.commu.id != null) {
        comments = await commuServices.fetchComment(context, widget.commu.id!);
        // print(comments);
      } else {
        print("CommuId is null");
      }
    } catch (e) {
      print(e.toString());
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //แสดงความคิดเห็น
  void addComment() async {
    if (_sendCommentFormKey.currentState?.validate() ?? false) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      await commuServices.addComment(
        user_id: userId,
        context: context,
        message: commentController.text,
        commu_id: widget.commu.id!,
      );
    }
  }

  //ลบCommu
  void delete(String commu) {
    profileService.deleteCommu(context, commu);
  }

  @override
  void dispose() {
    if (mounted) {
      commentController.dispose();
    }
    super.dispose();
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
                child: ReportScreen(
                  commu: widget.commu,
                )),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadComments,
        child: SingleChildScrollView(
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
                      widget.commu.user!.imagesP,
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
                  Spacer(),
                ],
              ),
            ),
            if (widget.commu.images.isNotEmpty)
              CustomCarouselSlider(
                images: widget.commu.images,
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.commu.title}",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                          const TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${widget.commu.description}",
                    style: Theme.of(context).textTheme.subtitle2!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start, // You can use this to explicitly align to the start
                    children: [
                      Text(
                        formatDateTime(widget.commu.createdAt),
                        style: Theme.of(context).textTheme.subtitle2!.merge(
                              TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                      ),

                      Spacer(), // This will take all available space pushing the following widgets to the end
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
                    padding: const EdgeInsets.only(bottom: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comments
                        .map(
                          (comment) => Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            comment.user!.imagesP,
                                          ),
                                          radius: 15),
                                      SizedBox(width: 10),
                                      Text(
                                        comment.user!.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      if (user ==
                                          comment
                                              .user_id) // Display delete button only if the current user is the owner
                                        IconButton(
                                          onPressed: () {
                                            commuServices.deleteComment(
                                                context, comment.id!);
                                          },
                                          icon: Icon(Icons.delete_sharp),
                                        )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, bottom: 10),
                                    child: Text(
                                      comment.message,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 10),
                                    child: Text(
                                      formatDateTime(comment.createdAt),
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
                          ),
                        )
                        .toList(),
                  ),
                  Form(
                    key: _sendCommentFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: commentController,
                          scrollPadding: const EdgeInsets.all(20.0),
                          decoration: InputDecoration(
                            hintText: "แสดงความคิดเห็น",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'กรุณาแสดงความคิดเห็น';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'ส่ง',
                          onTap: () {
                            if (_sendCommentFormKey.currentState!.validate()) {
                              addComment();
                              commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
