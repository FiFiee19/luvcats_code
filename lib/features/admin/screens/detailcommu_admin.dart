import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:provider/provider.dart';

class DetailCommuAdmin extends StatefulWidget {
  final Commu commu;
  const DetailCommuAdmin({
    Key? key,
    required this.commu,
  }) : super(key: key);

  @override
  State<DetailCommuAdmin> createState() => _DetailCommuAdminState();
}

class _DetailCommuAdminState extends State<DetailCommuAdmin> {
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

  //ลบโพสต์
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
  void dispose() {
    if (mounted) {
      commentController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user.id;
    final userType = userProvider.user.type;
    return Scaffold(
      appBar: AppBar(),
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Spacer(),
                  if (userType == 'admin')
                    IconButton(
                        onPressed: () {
                          _showDeleteDialog(widget.commu.id!);
                        },
                        icon: Icon(Icons.delete_sharp)),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${widget.commu.description}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(
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

                      Spacer(), // This will take all available space pushing the following widgets to the end
                      IconButton(
                        icon: widget.commu.likes.contains(user)
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
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
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
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
