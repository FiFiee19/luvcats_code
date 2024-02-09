import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/widgets/loader.dart';

class CatHotelScreen extends StatefulWidget {
  const CatHotelScreen({super.key});

  @override
  State<CatHotelScreen> createState() => _CatHotelScreenState();
}

class _CatHotelScreenState extends State<CatHotelScreen> {
  List<Cathotel>? cathotel;
  final CathotelServices cathotelServices = CathotelServices();
  final AuthService authService = AuthService();
  String? finalEmail;

  @override
  void initState() {
    super.initState();
    fetchAllCathotel();
  }

  Future<void> fetchAllCathotel() async {
    cathotel = await cathotelServices.fetchAllCathotel(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (cathotel == null) {
      bodyContent = const Loader();
    } else if (cathotel!.isEmpty) {
      bodyContent = RefreshIndicator(
          onRefresh: fetchAllCathotel,
          child: Center(
            child: Text(
              'No Post',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ));
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: fetchAllCathotel,
        child: GridView.builder(
          itemCount: cathotel!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 330,
          ),
          itemBuilder: (context, index) {
            final catData = cathotel![index];

            return InkWell(
              onTap: () {
                // ทำสิ่งที่คุณต้องการเมื่อกดที่ Container
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailStraycatScreen(cat: catData),
                //   ),
                // );
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
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            catData.description.length > 60
                                ? "${catData.description.substring(0, 60)}..."
                                : catData.description,
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
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
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // ใช้ spaceBetween ที่นี่
                            children: [
                              // วิดเจ็ตสำหรับแสดง province
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
                              // วิดเจ็ตสำหรับแสดง price
                              Text(
                                "${catData.price}/คืน",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red,
                                      ),
                                    ),
                              ),
                              SizedBox(
                                width: 3,
                              )
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
      backgroundColor: Colors.grey[200],
      body: bodyContent,
    );
  }
}
