import 'package:luvcats_app/models/maps/geometry.dart';

class Place {
  final Geometry? geometry; 
  final String? name; 
  final String? vicinity;

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> map) {
    return Place(
      geometry: Geometry.fromJson(map['geometry']),
      name: map['name'],
      vicinity: map['vicinity'],
    );
  }
}
