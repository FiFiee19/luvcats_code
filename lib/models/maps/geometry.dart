import 'package:luvcats_app/models/maps/location.dart';

class Geometry {
  final Location? location; //ข้อมูลละติจูดและลองจิจูด

  Geometry({this.location});

  Geometry.fromJson(Map<dynamic,dynamic> map)
      :location = Location.fromJson(map['location']);
}