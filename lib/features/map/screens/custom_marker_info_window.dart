// // import 'dart:async';
// // import 'dart:convert';

// // import 'package:custom_info_window/custom_info_window.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:luvcats_app/models/map.dart';

// // class CustomMarketInfoWindow extends StatefulWidget {
// //   const CustomMarketInfoWindow({Key? key}) : super(key: key);

// //   @override
// //   State<CustomMarketInfoWindow> createState() => _CustomMarketInfoWindowState();
// // }

// // class _CustomMarketInfoWindowState extends State<CustomMarketInfoWindow> {
// //   CustomInfoWindowController _customInfoWindowController =
// //       CustomInfoWindowController();
// //   Completer<GoogleMapController> _controller = Completer();
// //   final List<Marker> _marker = [];
// //   NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
// //   double currentLat = 0.0;
// //   double currentLng = 0.0;
// //   String type = 'restaurant';

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     // loadData();
// //     // navigateToCurrentPosition();
// //     // getNearbyPlaces();
// //     // loadData();
// //   }

// //   @override
// //   void dispose() {
// //     // Cancel any subscriptions or timers here
// //     _customInfoWindowController.dispose(); // If it has a dispose method
// //     super.dispose();
// //   }

// //   loadData() {
// //     if (nearbyPlacesResponse.results != null) {
// //       for (int i = 0; i < nearbyPlacesResponse.results!.length; i++) {
// //         addMarkers(nearbyPlacesResponse.results![i], i);
// //       }
// //     }
// //   }

// //   void addMarkers(Results results, int i) {
// //     _marker.add(Marker(
// //       markerId: MarkerId(i.toString()),
// //       icon: BitmapDescriptor.defaultMarker,
// //       position: LatLng(
// //           results.geometry!.location!.lat!, results.geometry!.location!.lng!),
// //     ));

// //     setState(() {});
// //   }

// //   Future<Position> getUserCurrentLocation() async {
// //     await Geolocator.requestPermission()
// //         .then((value) {})
// //         .onError((error, stackTrace) {
// //       debugPrint('error in getting current location');
// //       debugPrint(error.toString());
// //     });

// //     return await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);
// //   }

// //   void navigateToCurrentPosition() {
// //     getUserCurrentLocation().then((value) async {
// //       debugPrint('My current location');
// //       debugPrint(value.latitude.toString() + value.longitude.toString());

// //       _marker.add(Marker(
// //           markerId: MarkerId("yeiuwe87"),
// //           position: LatLng(value.latitude, value.longitude),
// //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
// //           infoWindow: InfoWindow(
// //             title: 'My current location',
// //           )));

// //       CameraPosition cameraPosition = CameraPosition(
// //         target: LatLng(value.latitude, value.longitude),
// //         zoom: 14,
// //       );

// //       final GoogleMapController controller = await _controller.future;
// //       controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
// //       setState(() {
// //         currentLat = value.latitude;
// //         currentLng = value.longitude;
// //         getNearbyPlaces(type);
// //       });
// //     });
// //   }

// //   static const CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(37.42796133580664, -122.085749655962),
// //     zoom: 14.4746,
// //   );

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         actions: [
// //           PopupMenuButton(
// //               // add icon, by default "3 dot" icon
// //               // icon: Icon(Icons.book)
// //               itemBuilder: (context) {
// //             return [
// //               PopupMenuItem<int>(
// //                 value: 0,
// //                 child: Text("Restaurant"),
// //               ),
// //               PopupMenuItem<int>(
// //                 value: 1,
// //                 child: Text("Hospital"),
// //               ),
// //               PopupMenuItem<int>(
// //                 value: 2,
// //                 child: Text("Mosque"),
// //               ),
// //             ];
// //           }, onSelected: (value) {
// //             if (value == 0) {
// //               type = 'restaurant';
// //               getNearbyPlaces(type);
// //             } else if (value == 1) {
// //               type = 'hospital';
// //               getNearbyPlaces(type);
// //             } else if (value == 2) {
// //               type = 'mosque';
// //               getNearbyPlaces(type);
// //             }
// //           }),
// //         ],
// //       ),
// //       body: Stack(
// //         children: [
// //           GoogleMap(
// //             initialCameraPosition: _kGooglePlex,
// //             myLocationEnabled: true,
// //             onMapCreated: (GoogleMapController controller) {
// //               _controller.complete(controller);
// //             },
// //             markers: Set<Marker>.of(_marker),
// //           ),
// //           CustomInfoWindow(
// //             controller: _customInfoWindowController,
// //             height: 0,
// //             width: 0,
// //             offset: 0,
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   void getNearbyPlaces(String type) async {
// //     _marker.clear();
// //     var url = Uri.parse(
// //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
// //             currentLat.toString() +
// //             ',' +
// //             currentLng.toString() +
// //             '&radius=1500&type=' +
// //             type +
// //             '&key=AIzaSyBZt_71z4Dditm38hvi5DLAz0zfF4EzJK0');

// //     var response = await http.post(url);

// //     print("printing latlng");
// //     print(jsonDecode(response.body));
// //     nearbyPlacesResponse =
// //         NearbyPlacesResponse.fromJson(jsonDecode(response.body));
// //     print("printing latlng");
// //     print(jsonDecode(response.body));

// //     loadData();
// //     if (mounted) {
// //       setState(() {});
// //     }
// //   }
// // }
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/models/map.dart';

class MapController extends GetxController {
  List<MapModel> mapModel = <MapModel>[].obs;
  var markers = RxSet<Marker>();
  var isLoading = false.obs;

  fetchLocations() async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse('{YOUR_URL}')!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        log(result.toString());
        mapModel.addAll(RxList<Map<String, dynamic>>.from(result)
            .map((e) => MapModel.fromJson(e))
            .toList());
      } else {
        print('error fetching data');
      }
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      isLoading(false);
      print('finaly: $mapModel');
      createMarkers();
    }
  }

  createMarkers() {
    mapModel.forEach((element) {
      markers.add(Marker(
        markerId: MarkerId(element.id.toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(element.latitude, element.longitude),
        infoWindow: InfoWindow(title: element.name, snippet: element.city),
        onTap: () {
          print('market tapped');
        },
      ));
    });
  }
}
