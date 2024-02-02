import 'dart:convert';

class Cathotel {
  final String id;
  final String user_id;
  final String description;
  final String price;
  final String contact;
  final String province;
  final List<String> images;
  Cathotel({
    required this.id,
    required this.user_id,
    required this.description,
    required this.price,
    required this.contact,
    required this.province,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'description': description,
      'price': price,
      'contact': contact,
      'province': province,
      'images': images,
    };
  }

  factory Cathotel.fromMap(Map<String, dynamic> map) {
    return Cathotel(
      id: map['_id'] ?? '',
      user_id: map['user_id'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      contact: map['contact'] ?? '',
      province: map['province'] ?? '',
      images: map['images'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cathotel.fromJson(String source) =>
      Cathotel.fromMap(json.decode(source));
}
