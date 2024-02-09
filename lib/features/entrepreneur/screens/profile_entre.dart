import 'package:flutter/material.dart';

class Profile_Entre extends StatefulWidget {
  const Profile_Entre({super.key});

  @override
  State<Profile_Entre> createState() => _Profile_EntreState();
}

class _Profile_EntreState extends State<Profile_Entre> {
  // Cathotel? cathotel;
  // final CathotelServices cathotelServices = CathotelServices();
  // final AuthService authService = AuthService();

  // CarouselController buttonCarouselController = CarouselController();
  // int _current = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchProfile();
  // }

  // Future<void> fetchProfile() async {
  //   cathotel = await cathotelServices.;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
    // final commuData = cathotel!;
    // return Scaffold(
    //   backgroundColor: Colors.grey[200],
    //   body: RefreshIndicator(
    //     onRefresh: fetchProfile,
    //     child:

    //          Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5.0),
    //             color: Colors.white,
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(
    //                   children: [
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     CircleAvatar(
    //                       backgroundColor: Colors.grey,
    //                       backgroundImage: NetworkImage(
    //                         commuData.user!.imagesP,
    //                       ),
    //                       radius: 20,
    //                     ),
    //                     SizedBox(
    //                       width: 20,
    //                     ),
    //                     Text(
    //                       "${commuData.user!.username}",
    //                       style: Theme.of(context).textTheme.subtitle1!.merge(
    //                             const TextStyle(
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w700,
    //                                 color: Colors.black),
    //                           ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               CarouselSlider(
    //                 items: commuData.images.map(
    //                   (i) {
    //                     return Builder(
    //                       builder: (BuildContext context) => Image.network(
    //                         i,
    //                         fit: BoxFit.contain,
    //                         height: 300,
    //                       ),
    //                     );
    //                   },
    //                 ).toList(),
    //                 carouselController: buttonCarouselController,
    //                 options: CarouselOptions(
    //                   viewportFraction: 1,
    //                   height: 200,
    //                   enableInfiniteScroll: false,
    //                   onPageChanged: (index, reason) {
    //                     setState(() {
    //                       _current = index; // อัปเดตตำแหน่งสไลด์ปัจจุบัน
    //                     });
    //                   },
    //                 ),
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: commuData.images.asMap().entries.map((entry) {
    //                   return GestureDetector(
    //                     onTap: () =>
    //                         buttonCarouselController.animateToPage(entry.key),
    //                     child: Container(
    //                       width: 12.0,
    //                       height: 12.0,
    //                       margin: EdgeInsets.symmetric(
    //                           vertical: 8.0, horizontal: 4.0),
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         color: _current == entry.key
    //                             ? Theme.of(context).primaryColor
    //                             : Theme.of(context)
    //                                 .primaryColor
    //                                 .withOpacity(0.3),
    //                       ),
    //                     ),
    //                   );
    //                 }).toList(),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(15.0),
    //                 child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const SizedBox(
    //                         height: 10.0,
    //                       ),
    //                       Text(
    //                         "${commuData.description}",
    //                         style: Theme.of(context).textTheme.subtitle2!.merge(
    //                               TextStyle(
    //                                 fontWeight: FontWeight.w700,
    //                                 color: Colors.grey.shade500,
    //                               ),
    //                             ),
    //                       ),
    //                       const SizedBox(
    //                         height: 10.0,
    //                       ),
    //                     ]),
    //               ),
    //             ],
    //           ),
    //         );
    //       },

    //   ),
    // );
  }
}
