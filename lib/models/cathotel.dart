import 'dart:convert';

import 'package:luvcats_app/models/user.dart';

class Cathotel {
  final String id;
  User? user;
  final String user_id;
  final String description;
  final double price;
  final String contact;
  final String province;
  final List<String> images;
  Cathotel({
    this.user,
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
      'user': user?.toMap(),
      'user_id': user_id,
      'description': description,
      'price': price,
      'contact': contact,
      'province': province,
      'images': images,
    };
  }

  factory Cathotel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Cathotel(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      id: map['_id'] ?? '',
      user_id: map['user_id'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      contact: map['contact'] ?? '',
      province: map['province'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cathotel.fromJson(String source) =>
      Cathotel.fromMap(json.decode(source));
}
