import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/report/screens/forms_report.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
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

  final GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  //เรียกข้อมูลCommentsจากcommuServices
  Future<void> fetchComments() async {
    if (widget.commu.id != null) {
      comments = await commuServices.fetchComment(context, widget.commu.id!);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //แสดงความคิดเห็น
  void addComment() async {
    if (commentFormKey.currentState?.validate() ?? false) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      await commuServices.addComment(
        user_id: userId,
        context: context,
        message: commentController.text,
        commu_id: widget.commu.id!,
      );
      fetchComments();
    }
  }

  //ลบCommu
  void _showDeleteDialog(String cemment) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'ลบคอมเมนต์',
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
              await commuServices.deleteComment(context, cemment);

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
      appBar: AppBar(
        title: Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 220),
              child: FormsReport(
                commu: widget.commu,
              )),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchComments,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      widget.commu.user!.imagesP,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.commu.user!.username,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  const Spacer(),
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
                    widget.commu.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.commu.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        formatDateTime(widget.commu.createdAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
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
                        "${widget.commu.likes.length}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                      const SizedBox(width: 10),
                                      Text(
                                        comment.user!.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      if (user == comment.user_id)
                                        IconButton(
                                          onPressed: () {
                                            _showDeleteDialog(comment.id!);
                                          },
                                          icon: const Icon(Icons.delete_sharp),
                                        )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 20, bottom: 10),
                                    child: Text(
                                      comment.message,
                                      style: const TextStyle(
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
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
                    key: commentFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: commentController,
                          scrollPadding: const EdgeInsets.all(20.0),
                          decoration: const InputDecoration(
                            hintText: "แสดงความคิดเห็น",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            enabledBorder: OutlineInputBorder(
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
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'ส่ง',
                          onTap: () {
                            if (commentFormKey.currentState!.validate()) {
                              addComment();
                              commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
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
