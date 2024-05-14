import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luvcats_app/features/map/services/geolocator_service.dart';
import 'package:luvcats_app/features/map/services/marker_service.dart';
import 'package:luvcats_app/features/map/services/places_service.dart';
import 'package:luvcats_app/models/maps/geometry.dart';
import 'package:luvcats_app/models/maps/location.dart';
import 'package:luvcats_app/models/maps/place.dart';
import 'package:luvcats_app/models/maps/place_search.dart';
import 'package:rxdart/rxdart.dart';

class MapApp with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  Position? currentLocation;
  List<PlaceSearch>? searchResults;
  BehaviorSubject<Place?> selectedLocation = BehaviorSubject<Place?>();
  BehaviorSubject<LatLngBounds?> bounds = BehaviorSubject<LatLngBounds?>();
  Place? selectedLocationStatic;
  String? placeType;
  List<Marker>? markers = [];
  MapApp() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    if (currentLocation != null) {
      selectedLocationStatic = Place(
        name: null,
        geometry: Geometry(
          location: Location(
            lat: currentLocation!.latitude.toDouble(),
            lng: currentLocation!.longitude.toDouble(),
          ),
        ),
      );
    } 
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.sink.add(sLocation);

    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  togglePlaceType(
      String value, bool selected, double maxDistanceInKilometers) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null && selectedLocationStatic != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic!.geometry!.location!.lat!,
          selectedLocationStatic!.geometry!.location!.lng!,
          placeType!);

      var filteredPlaces = places.where((place) {
        var distanceInMeters = Geolocator.distanceBetween(
          selectedLocationStatic!.geometry!.location!.lat!,
          selectedLocationStatic!.geometry!.location!.lng!,
          place.geometry!.location!.lat!,
          place.geometry!.location!.lng!,
        );

        return distanceInMeters / 1000 <= maxDistanceInKilometers;
      }).toList();

      markers = [];
      for (var place in filteredPlaces) {
        markers!.add(markerService.createMarkerFromPlace(place, false));
      }

      if (markers!.isNotEmpty) {
        var _bounds = markerService.bounds(Set<Marker>.of(markers!));
        bounds.sink.add(_bounds);
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
