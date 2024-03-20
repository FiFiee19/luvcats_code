import 'package:flutter/material.dart';
import 'package:luvcats_app/config/province.dart';
import 'package:luvcats_app/features/straycat/services/straycats_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';

class FilterProvince extends StatefulWidget {
  const FilterProvince({super.key});

  @override
  State<FilterProvince> createState() => _FilterProvinceState();
}

class _FilterProvinceState extends State<FilterProvince> {
  String? selectedProvince;
  List<Straycat>? straycatlist;
  List<Straycat>? filteredStraycatlist;
  final CatServices catServices = CatServices();

  @override
  void initState() {
    super.initState();
    fetchAllCats();
  }

  Future<void> fetchAllCats() async {
    straycatlist = await catServices.fetchAllCats(context);
    filteredStraycatlist = straycatlist;
    if (mounted) {
      setState(() {});
    }
  }

  void filterStraycatsByProvince(String? selectedProvince) {
    if (selectedProvince != null) {
      setState(() {
        filteredStraycatlist = straycatlist
            ?.where((straycat) => straycat.province == selectedProvince)
            .toList();
      });
    } else {
      setState(() {
        filteredStraycatlist = straycatlist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: const Text(
              'จังหวัด',
              style: TextStyle(fontSize: 14),
            ),
            value: selectedProvince,
            items: province.map((String province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(
                  province,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedProvince = value;
              });
              filterStraycatsByProvince(value);
            },
          ),
        ],
      ),
    );
  }
}
