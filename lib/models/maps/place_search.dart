class PlaceSearch {
  final String? description;
  final String? placeId;

  PlaceSearch({this.description, this.placeId});

  factory PlaceSearch.fromJson(Map<String,dynamic> map){
    return PlaceSearch(
        description: map['description'],
        placeId: map['place_id']
    );
  }
}