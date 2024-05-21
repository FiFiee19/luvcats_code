import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvcats_app/features/map/screens/mapapp.dart';
import 'package:luvcats_app/models/maps/place.dart';
import 'package:provider/provider.dart';

class HospitalMapScreen extends StatefulWidget {
  HospitalMapScreen({Key? key}) : super(key: key);

  @override
  _HospitalMapScreenState createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription? locationSubscription;
  StreamSubscription? boundsSubscription;
  final _locationController = TextEditingController();

  @override
  void dispose() {
    locationSubscription?.cancel();
    boundsSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final mapApp = Provider.of<MapApp>(context, listen: false);
    mapApp.markers!.clear();
    locationSubscription =
        mapApp.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });

    boundsSubscription = mapApp.bounds.listen((bounds) async {
      if (bounds != null) {
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    });
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              place.geometry!.location!.lat!, place.geometry!.location!.lng!),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapApp = Provider.of<MapApp>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาโรงพยาบาลสัตว์'),
        centerTitle: true,
      ),
      body: mapApp.currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _locationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาสถานที่',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => mapApp.searchPlaces(value),
                      onTap: () => mapApp.clearSelectedLocation(),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 595.0,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(mapApp.currentLocation!.latitude,
                                mapApp.currentLocation!.longitude),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                          },
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: Set<Marker>.of(mapApp.markers!),
                        ),
                      ),
                      if (mapApp.searchResults != null &&
                          mapApp.searchResults!.length != 0)
                        Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                backgroundBlendMode: BlendMode.darken)),
                      if (mapApp.searchResults != null)
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                              itemCount: mapApp.searchResults!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    mapApp.searchResults![index].description!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    mapApp.setSelectedLocation(
                                        mapApp.searchResults![index].placeId!);
                                  },
                                );
                              }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: FloatingActionButton(
          onPressed: () => Provider.of<MapApp>(context, listen: false)
              .togglePlaceType("veterinary_care", true, 3),
          child: Icon(Icons.filter_list),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
