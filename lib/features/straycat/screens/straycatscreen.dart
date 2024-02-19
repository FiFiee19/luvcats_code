import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/screens/forms_straycat.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:luvcats_app/widgets/search_profile.dart';

class StrayCatScreen extends StatefulWidget {
  const StrayCatScreen({Key? key}) : super(key: key);

  @override
  State<StrayCatScreen> createState() => _StrayCatScreenState();
}

class _StrayCatScreenState extends State<StrayCatScreen> {
  List<Straycat>? straycatlist;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
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

  Future<void> fetchAllCats() async {
  List<Straycat>? allCats = await catServices.fetchAllCats(context);
  if (allCats != null && mounted) { // Check if the widget is still mounted
    setState(() {
      straycatlist = allCats.where((cat) {
        final bool matchProvince = selectedProvince == null || cat.province == selectedProvince;
        final bool matchGender = selectedGender == null || cat.gender == selectedGender;
        return cat.status == 'no' && matchProvince && matchGender;
      }).toList();
    });
  }
}


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
                                ),
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
      appBar: AppBar(actions: [SearchProfile(),
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
                  items: province.map<DropdownMenuItem<String>>((String value) {
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
                  items:listgender.map<DropdownMenuItem<String>>((String value) {
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
    fetchAllCats(); // Refetch cats with new filters
  });
}

      },
    ),IconButton(
      icon: Icon(Icons.restart_alt_rounded),
      onPressed: () {
        setState(() {
          selectedProvince = null; 
          selectedGender = null;// Reset ค่า selectedProvince
          fetchAllCats(); // โหลดข้อมูลทั้งหมดอีกครั้ง
        });
      },
    ),]),
      backgroundColor: Colors.grey[200],
      body: Column(
    children: [
       SizedBox(height:10 ,),
      Expanded(
        child: bodyContent, // ส่วนที่เหลือของเนื้อหา
      ),
    ],
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
    
  }
  
}
