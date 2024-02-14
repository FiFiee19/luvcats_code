import 'package:flutter/material.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';

class DetailCathotelScreen extends StatefulWidget {
  final Cathotel cathotel;
  const DetailCathotelScreen({
    Key? key,
    required this.cathotel,
  }) : super(key: key);

  @override
  State<DetailCathotelScreen> createState() => _DetailCathotelScreenState();
}

class _DetailCathotelScreenState extends State<DetailCathotelScreen> {
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
            images: widget.cathotel.images,
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
                        widget.cathotel.user!.imagesP,
                      ),
                      radius: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.cathotel.user!.username,
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
                  "รายละเอียด: ",
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
                    widget.cathotel.description,
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
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ราคา:  " + widget.cathotel.price.toString() + "/คืน",
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
                  "จังหวัด:  " + widget.cathotel.province,
                  style: Theme.of(context).textTheme.subtitle2!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade900,
                        ),
                      ),
                ),
              ],
            ),
          ),Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ช่องทางการติดต่อ: ",
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
                  widget.cathotel.contact,
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
          
        ],
      )),
    );
  }
}
