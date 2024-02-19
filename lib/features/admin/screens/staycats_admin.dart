import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/screens/forms_straycat.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/loader.dart';

class StrayCatAdmin extends StatefulWidget {
  const StrayCatAdmin({
    Key? key,
  }) : super(key: key);


  @override
  State<StrayCatAdmin> createState() => _StrayCatAdminState();
}

class _StrayCatAdminState extends State<StrayCatAdmin> {
  List<Straycat>? straycatlist;
  Straycat? straycat;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  String? finalEmail;
  
  ProfileServices profileService = ProfileServices();

  @override
  void initState() {
    super.initState();
    fetchAllCats();
  }

  Future<void> fetchAllCats() async {
    straycatlist = await catServices.fetchAllCats(context);
    if (straycatlist != null) {
      // กรองเฉพาะ cats ที่มีสถานะเป็น "no"
      straycatlist = straycatlist!.where((cat) => cat.status == 'no').toList();
    }
    if (mounted) {
      setState(() {});
    }
  }
  void delete(String straycat) {
    profileService.deleteCatStrayCat(context, straycat);
  }
  // Future<void> fetchIdStraycats(Straycat straycat) async {
  
  //         await profileService.deleteCatStrayCat(context, );
    
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
if (straycatlist == null) {
      bodyContent = const Loader();
    } else if (straycatlist!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'No Post',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  builder: (context) => FormsStrayCat(),
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
        onRefresh: fetchAllCats,
        child: GridView.builder(
          itemCount: straycatlist!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 330,
          ),
          itemBuilder: (context, index) {
            final straycat = straycatlist![index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailStraycatScreen(straycat: straycat),
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
                            straycat.images[0],
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
                                  straycat.user!.imagesP,
                                ),
                                radius: 10,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${straycat.user?.username}",
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
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text("สายพันธุ์:  "),
                              Text(
                                straycat.breed.length > 10
                                    ? "${straycat.breed.substring(0, 10)}..."
                                    : straycat.breed,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            "เพศ:  ${straycat.gender}",
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Row(
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
                                "${straycat.province}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                              ),IconButton(
                                      onPressed: () {
                                        delete(straycat.id!);
                                      },
                                      icon: Icon(Icons.delete_sharp)),
                            ],
                          ),
                        ),
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
      appBar: AppBar(actions: [SearchBar()]),
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
                builder: (context) => FormsStrayCat(),
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
