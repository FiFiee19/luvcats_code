import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/detail_straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/screens/poststraycat.dart';
import 'package:luvcats_app/features/straycat/services/cat_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/loader.dart';

class StrayCatScreen extends StatefulWidget {
  const StrayCatScreen({Key? key}) : super(key: key);

  @override
  State<StrayCatScreen> createState() => _StrayCatScreenState();
}

class _StrayCatScreenState extends State<StrayCatScreen> {
  List<Cat>? cats;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  String? finalEmail;

  @override
  void initState() {
    super.initState();
    fetchAllCats();
  }

  Future<void> fetchAllCats() async {
    cats = await catServices.fetchAllCats(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (cats == null) {
      bodyContent = const Loader();
    } else if (cats!.isEmpty) {
      bodyContent = RefreshIndicator(
          onRefresh: fetchAllCats,
          child: Center(
            child: Text(
              'No Post',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ));
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: fetchAllCats,
        child: GridView.builder(
          itemCount: cats!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 330,
          ),
          itemBuilder: (context, index) {
            final catData = cats![index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailStraycatScreen(cat: catData),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: const EdgeInsets.all(10),
                          child: Image.network(
                            catData.images[0],
                            fit: BoxFit.fitHeight,
                            width: 180,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  catData.user!.imagesP,
                                ),
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${catData.user?.username}",
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
                                width: 96.0,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "สายพันธุ์: ${catData.breed.split(" ").first}",
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                          ),
                          Text(
                            "เพศ:   ${catData.gender}",
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${catData.province}",
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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: bodyContent,
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
                builder: (context) => PostStrayCat(),
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
