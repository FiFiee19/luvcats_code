import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/cathotel/screens/detail_cathotel.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/widgets/search_cathotel.dart';

class CatHotelScreen extends StatefulWidget {
  const CatHotelScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CatHotelScreen> createState() => _CatHotelScreenState();
}

class _CatHotelScreenState extends State<CatHotelScreen> {
  List<Cathotel>? cathotellist;
  Cathotel? cathotel;
  final CathotelServices cathotelServices = CathotelServices();
  final AuthService authService = AuthService();
  String? selectedProvince;
  String? selectedPrice;
  double _currentRangeStart = 0.0;
  double _currentRangeEnd = 100000.0;
  String startPrice = '';
  String endPrice = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllCathotel();
  }

  //เรียกข้อมูลAllCathotelในcathotelServices
  Future<void> fetchAllCathotel() async {
    List<Cathotel>? allcathotel =
        await cathotelServices.fetchAllCathotel(context);
    if (allcathotel != null && mounted) {
      setState(() {
        cathotellist = allcathotel.where((cathotel) {
          final bool matchProvince =
              selectedProvince == null || cathotel.province == selectedProvince;
          final bool matchPrice = cathotel.price >= _currentRangeStart &&
              cathotel.price <= _currentRangeEnd;
          return matchProvince && matchPrice;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (cathotellist == null) {
      bodyContent = Center(child: const CircularProgressIndicator());
    } else if (cathotellist!.isEmpty) {
      bodyContent = Center(
        child: Text(
          'No Post',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: fetchAllCathotel,
        child: GridView.builder(
          itemCount: cathotellist!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 350,
          ),
          itemBuilder: (context, index) {
            final catData = cathotellist![index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailCathotelScreen(cathotel: catData),
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
                                catData.user!.username.length > 15
                                    ? "${catData.user!.username.substring(0, 15)}..."
                                    : catData.user!.username,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                    catData.province.length > 10
                                        ? "${catData.province.substring(0, 10)}..."
                                        : catData.province,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .merge(
                                          TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  "${catData.price}/คืน",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CathotelSearchDelegate(cathotels: cathotellist ?? []),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<Map<String, String?>>(
                context: context,
                builder: (context) {
                  String? tempSelectedProvince = selectedProvince;
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
                              Text('เลือกช่วงราคา'),
                              TextField(
                                decoration:
                                    InputDecoration(hintText: "ราคาเริ่มต้น"),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  startPrice = value;
                                },
                              ),
                              TextField(
                                decoration:
                                    InputDecoration(hintText: "ราคาสิ้นสุด"),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  endPrice = value;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop({
                              'province': tempSelectedProvince,
                              'startPrice': startPrice,
                              'endPrice': endPrice,
                            }),
                            child: Text("ตกลง"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("ยกเลิก"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );

              if (result != null) {
                double start = result['startPrice']?.isNotEmpty ?? false
                    ? double.tryParse(result['startPrice']!) ?? 0.0
                    : 0.0;
                double end = result['endPrice']?.isNotEmpty ?? false
                    ? double.tryParse(result['endPrice']!) ?? 100000.0
                    : 100000.0;

                setState(() {
                  _currentRangeStart = start;
                  _currentRangeEnd = end;
                  selectedProvince = result['province'];
                  selectedPrice = result['price'];
                  fetchAllCathotel();
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.restart_alt_rounded),
            onPressed: () {
              setState(() {
                fetchAllCathotel();
                _currentRangeStart = 0.0;
                _currentRangeEnd = 100000.0;
                selectedProvince = null;
                startPrice = '';
                endPrice = '';
                fetchAllCathotel();
                selectedPrice = null;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: bodyContent,
    );
  }
}
