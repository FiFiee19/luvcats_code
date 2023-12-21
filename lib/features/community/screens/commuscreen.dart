import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/community/screens/postcommu.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:luvcats_app/widgets/single_cat.dart';

class CommScreen extends StatefulWidget {
  const CommScreen({super.key});

  @override
  State<CommScreen> createState() => _CommScreenState();
}

class _CommScreenState extends State<CommScreen> {
  List<Commu>? commu;
  final CommuServices commuServices = CommuServices();
  final AuthService authService = AuthService();
  int likes = 136;
  bool isLiked = false;
  void reactToPost() {
    setState(() {
      if (isLiked) {
        isLiked = false;
        likes--;
      } else {
        isLiked = true;
        likes++;
      }
    });
    print("Liked Post ? : $isLiked");
  }

  @override
  void initState() {
    super.initState();
    fetchAllCommu();
  }

  fetchAllCommu() async {
    commu = await commuServices.fetchAllCommu(context);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getData() async {
    setState(() {
      fetchAllCommu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return commu == null || commu!.isEmpty
        ? const Loader()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            body: RefreshIndicator(
              onRefresh: _getData,
              child: GridView.builder(
                itemCount: commu!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  mainAxisExtent: 400,
                ),
                itemBuilder: (context, index) {
                  final commuData = commu![index];

                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   // MaterialPageRoute(
                      //   //   builder: (context) =>
                      //   //       {StraycatDetailScreen(commu: commuData),}
                      //   // ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${commuData.user_id}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: SingleCat(
                              image: commuData.images[0],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${commuData.title}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  "${commuData.description}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 250),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        RawMaterialButton(
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            onPressed: () {}),
                                        Text(likes.toString(),
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ],
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
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostCommu(),
                    ),
                  );
                },
                shape: const CircleBorder(),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
          );
  }
}
