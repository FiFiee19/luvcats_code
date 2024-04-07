import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/search_profile.dart';

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

  ProfileServices profileService = ProfileServices();
  String? selectedProvince;
  String? selectedGender;
  final List<String> listgender = [
    'ผู้',
    'เมีย',
    'ไม่ทราบ',
  ];
  @override
  void initState() {
    super.initState();
    fetchAllCats();
  }

  //เรียกข้อมูลAllCatsจากcatServices
  Future<void> fetchAllCats() async {
    List<Straycat>? allCats = await catServices.fetchAllCats(context);

    if (allCats != null && mounted) {
      allCats.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));

      setState(() {
        straycatlist = allCats.where((cat) {
          final bool matchProvince =
              selectedProvince == null || cat.province == selectedProvince;
          final bool matchGender =
              selectedGender == null || cat.gender == selectedGender;
          return cat.status == 'no' && matchProvince && matchGender;
        }).toList();
      });
    }
  }

  void _showDeleteDialog(String straycat) {
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
              await profileService.deleteStrayCat(context, straycat);

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
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (straycatlist == null) {
      bodyContent = Center(child: const CircularProgressIndicator());
    } else if (straycatlist!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'ไม่มีโพสต์',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
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
                    builder: (context) =>
                        DetailStraycatScreen(straycat: straycat),
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
                                straycat.user!.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "สายพันธุ์:  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Text(
                                straycat.breed.length > 10
                                    ? "${straycat.breed.substring(0, 10)}..."
                                    : straycat.breed,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "เพศ:  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Text(
                                straycat.gender,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ],
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
                                straycat.province,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    _showDeleteDialog(straycat.id!);
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
      appBar: AppBar(actions: [
        SearchProfile(),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () async {
            final result = await showDialog<Map<String, String?>>(
              context: context,
              builder: (context) {
                String? tempSelectedProvince = selectedProvince;
                String? tempSelectedGender = selectedGender;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("กรองข้อมูล"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: tempSelectedProvince,
                              hint: Text("เลือกจังหวัด"),
                              items: province.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  tempSelectedProvince = value;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: tempSelectedGender,
                              hint: Text("เลือกเพศ"),
                              items: listgender.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  tempSelectedGender = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("ยกเลิก"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop({
                            'province': tempSelectedProvince,
                            'gender': tempSelectedGender,
                          }),
                          child: Text("ตกลง"),
                        ),
                      ],
                    );
                  },
                );
              },
            );

            if (result != null) {
              setState(() {
                selectedProvince = result['province'];
                selectedGender = result['gender'];
                fetchAllCats();
              });
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.restart_alt_rounded),
          onPressed: () {
            setState(() {
              selectedProvince = null;
              selectedGender = null;
              fetchAllCats();
            });
          },
        ),
      ]),
      backgroundColor: Colors.grey[200],
      body: bodyContent,
    );
  }
}
