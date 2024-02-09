import 'package:flutter/material.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';

class DetailStraycatScreen extends StatefulWidget {
  final Cat cat;
  const DetailStraycatScreen({
    Key? key,
    required this.cat,
  }) : super(key: key);

  @override
  State<DetailStraycatScreen> createState() => _DetailStraycatScreenState();
}

class _DetailStraycatScreenState extends State<DetailStraycatScreen> {
  var selectedItem = '';
  @override
  Widget build(BuildContext context) {
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
          CustomCarouselSlider(
            images: widget.cat.images,
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
                        widget.cat.user!.imagesP,
                      ),
                      radius: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.cat.user!.username,
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                                fontSize: 16),
                          ),
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
                  "สายพันธุ์:  " + widget.cat.breed,
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
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "เพศ:  " + widget.cat.gender,
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
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "จังหวัด:  " + widget.cat.province,
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
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ข้อมูลเพิ่มเติม: ",
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
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.cat.description,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.subtitle2!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}