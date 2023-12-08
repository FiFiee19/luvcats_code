import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvcats_app/features/report/screens/reportscreen.dart';
import 'package:luvcats_app/models/poststraycat.dart';


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
            child: Text(
              '',
              style: GoogleFonts.kanit(
                color: Color.fromARGB(255, 247, 108, 185),
                fontSize: 30.0,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CarouselSlider(
            items: widget.cat.images.map(
              (i) {
                return Builder(
                  builder: (BuildContext context) => Image.network(
                    i,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                );
              },
            ).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: 300,
            ),
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
                    Text(
                      widget.cat.user_id,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 140),
                  child: ReportScreen()),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("สายพันธุ์: " + widget.cat.breed),
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
                  "อายุ:  " + widget.cat.province,
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
                  "ข้อมูลเพิ่มเติม:  " + widget.cat.description,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
