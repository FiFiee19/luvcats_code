import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/features/entrepreneur/screens/editprofile_entre.dart';
import 'package:luvcats_app/features/profile/screens/editprofile.dart';
import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Profile_Entre extends StatefulWidget {
  const Profile_Entre({super.key});

  @override
  State<Profile_Entre> createState() => _Profile_EntreState();
}

class _Profile_EntreState extends State<Profile_Entre> {
  Cathotel? cathotel;
  final CathotelServices cathotelServices = CathotelServices();
  final AuthService authService = AuthService();

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    cathotel =
        await cathotelServices.fetchCatIdProfile(context, userProvider.user.id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cathotel == null) {
      // Show a loading spinner or some placeholder content
      // if cathotel is null when the widget builds
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final cathotelData = cathotel!;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 220),
                  child: ElevatedButton(
                    child: Text(
                      'แก้ไขโปรไฟล์',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileEntre(CathotelId: cathotelData.id,),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          cathotelData.user!.imagesP,
                        ),
                        radius: 50,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        cathotelData.user!.username,
                        style: Theme.of(context).textTheme.subtitle1!.merge(
                              const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                  items: cathotelData.images.map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) => Image.network(
                          i,
                          fit: BoxFit.contain,
                          height: 300,
                        ),
                      );
                    },
                  ).toList(),
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 200,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index; // อัปเดตตำแหน่งสไลด์ปัจจุบัน
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cathotelData.images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () =>
                          buttonCarouselController.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "รายละเอียด: ",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                        ),
                        Text(
                          "${cathotelData.description}",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "ราคา: ",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                        ),
                        Text(
                          "${cathotelData.price} /คืน",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "ช่องทางการติดต่อ: ",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                        ),
                        Text(
                          "${cathotelData.contact}",
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
