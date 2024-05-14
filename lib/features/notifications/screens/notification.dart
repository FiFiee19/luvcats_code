import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/comment.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationUser extends StatefulWidget {
  const NotificationUser({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationUser> createState() => _NotificationUserState();
}

class _NotificationUserState extends State<NotificationUser> {
  final CommuServices commuServices = CommuServices();
  List<Comment>? comment;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    fetchComments(userId);
  }

  Future<void> fetchComments(String userId) async {
    try {
      var comments = await commuServices.noti_Comment(context, userId);
      if (mounted) {
        comments.sort((a, b) => DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!)));

        setState(() {
          comment = comments;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          comment = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('การแจ้งเตือน'),
      ),
      backgroundColor: Colors.grey[200],
      body: comment == null
          ? const LinearProgressIndicator()
          : comment!.isEmpty
              ? const Center(child: Text('ไม่มีคอมเมนต์'))
              : RefreshIndicator(
                  onRefresh: () => fetchComments(userProvider.id),
                  child: ListView.builder(
                    itemCount: comment!.length,
                    itemBuilder: (context, index) {
                      final commentData = comment![index];
                      if (commentData.user!.id == userProvider.id) {
                        // ไม่แสดงคอมเมนต์ของตนเอง
                        return Container();
                      } else {
                        return buildCommentItem(commentData, context);
                      }
                    },
                  ),
                ),
    );
  }

  Widget buildCommentItem(Comment commentData, BuildContext context) {
    return InkWell(
      onTap: () async {
        final commuId = commentData.commu_id;
        if (commuId != null) {
          final commu = await commuServices.fetchIdCommu(context, commuId);
          if (commu != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailCommentScreen(commu: commu),
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            commentData.user!.imagesP,
                          ),
                          radius: 15),
                      const SizedBox(width: 10),
                      Text(
                        commentData.user!.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 10),
                    child: Row(
                      children: [
                        const Text('แสดงความคิดเห็น'),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('"'),
                        Text(
                          commentData.message.length > 10
                              ? "${commentData.message.substring(0, 10)}..."
                              : commentData.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Text('"'),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Text(
                          formatDateTime(commentData.createdAt),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
