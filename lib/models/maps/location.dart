class Location{
  final double? lat; //ละติจูด
  final double? lng; //ลองจิจูด

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<dynamic,dynamic> map){
    return Location(
        lat: map['lat'],
        lng: map['lng']
    );
  }

}