import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:provider/provider.dart';

class DetailStraycatScreen extends StatefulWidget {
  final Straycat straycat;
  const DetailStraycatScreen({
    Key? key,
    required this.straycat,
  }) : super(key: key);

  @override
  State<DetailStraycatScreen> createState() => _DetailStraycatScreenState();
}

class _DetailStraycatScreenState extends State<DetailStraycatScreen> {
  final ProfileServices profileService = ProfileServices();
  //ลบStrayCat
  void delete(String straycat) {
    profileService.deleteStrayCat(context, straycat);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = userProvider.user.type;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(title: Text('')),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CustomCarouselSlider(
            images: widget.straycat.images,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        widget.straycat.user!.imagesP,
                      ),
                      radius: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.straycat.user!.username,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "สายพันธุ์:  " + widget.straycat.breed,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "เพศ:  " + widget.straycat.gender,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ข้อมูลเพิ่มเติม: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.straycat.description,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "จังหวัด:  " + widget.straycat.province,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateTime(widget.straycat.createdAt),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (userType == 'admin')
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        delete(widget.straycat.id!);
                      },
                      icon: Icon(Icons.delete_sharp)),
                ],
              ),
            ),
        ],
      )),
    );
  }
}
