import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvcats_app/features/map/screens/application_bloc.dart';
import 'package:luvcats_app/models/maps/place.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation!.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });

    boundsSubscription = applicationBloc.bounds!.stream.listen((bounds) async {
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
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: applicationBloc.currentLocation == null
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
                        hintText: 'Search by City',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => applicationBloc.searchPlaces(value),
                      onTap: () => applicationBloc.clearSelectedLocation(),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 540.0,
                        child: Expanded(
                          child: GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  applicationBloc.currentLocation!.latitude,
                                  applicationBloc.currentLocation!.longitude),
                              zoom: 14,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            markers: Set<Marker>.of(applicationBloc.markers!),
                            // Add more configurations if needed
                          ),
                        ),
                      ),
                      if (applicationBloc.searchResults != null &&
                          applicationBloc.searchResults!.length != 0)
                        Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                backgroundBlendMode: BlendMode.darken)),
                      if (applicationBloc.searchResults != null)
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                              itemCount: applicationBloc.searchResults!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    applicationBloc
                                        .searchResults![index].description!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    applicationBloc.setSelectedLocation(
                                        applicationBloc
                                            .searchResults![index].placeId!);
                                  },
                                );
                              }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterModal(context),
        child: Icon(Icons.filter_list),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Pet Store'),
                onTap: () => Navigator.pop(context, 'pet_store'),
              ),
              ListTile(
                leading: Icon(Icons.local_hospital),
                title: Text('Pet Hospital'),
                onTap: () => Navigator.pop(context, 'veterinary_care'),
              ),
              // Add more ListTile rows for other place types
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        Provider.of<ApplicationBloc>(context, listen: false)
            .togglePlaceType(value, true, 4);
      }
    });
  }
}
