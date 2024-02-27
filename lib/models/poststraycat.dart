import 'dart:convert';
import 'package:luvcats_app/models/user.dart';

class Straycat {
  User? user;
  final String user_id;
  final String breed;
  final String gender;
  final String province;
  final String description;
  final String? id;
  final List<String> images;
  final String? status;
final String? createdAt;
  Straycat({
    this.user,
    required this.user_id,
    required this.breed,
    required this.gender,
    required this.province,
    required this.description,
    this.id,
    required this.images,
    this.status,
     this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'user_id': user_id,
      'breed': breed,
      'gender': gender,
      'province': province,
      'description': description,
      'id': id,
      'images': images,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory Straycat.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Straycat(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      user_id: map['user_id'] ?? '',
      breed: map['breed'] ?? '',
      gender: map['gender'] ?? '',
      province: map['province'] ?? '',
      description: map['description'] ?? '',
      status: map['status'],
      id: map['_id'],
      images: List<String>.from(map['images'] ?? []),
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Straycat.fromJson(String source) => Straycat.fromMap(json.decode(source));

  
}
