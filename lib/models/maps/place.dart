import 'package:luvcats_app/models/maps/geometry.dart';

class Place {
  final Geometry? geometry; //ตำแหน่งทางภูมิศาสตร์ของสถานที่
  final String? name; //ชื่อสถานที่
  final String? vicinity; //บริเวณใกล้เคียงของสถานที่

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> map) {
    return Place(
      geometry: Geometry.fromJson(map['geometry']),
      name: map['name'],
      vicinity: map['vicinity'],
    );
  }
}
