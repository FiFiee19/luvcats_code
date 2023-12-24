import 'dart:convert';

import 'package:luvcats_app/models/user.dart';

class Cat {
  final String user_id;
  final String breed;
  final String gender;
  final String province;
  final String description;
  final String? id;
  final List<String> images;

  Cat({
    required this.user_id,
    required this.breed,
    required this.gender,
    required this.province,
    required this.description,
    this.id,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'breed': breed,
      'gender': gender,
      'province': province,
      'description': description,
      'id': id,
      'images': images,
    };
  }

  factory Cat.fromMap(Map<String, dynamic>? map) {
    return Cat(
      user_id: map?['user_id'] ?? '',
      breed: map?['breed'] ?? '',
      gender: map?['gender'] ?? '',
      province: map?['province'] ?? '',
      description: map?['description'] ?? '',
      id: map?['_id'],
      images: List<String>.from(map?['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cat.fromJson(String source) => Cat.fromMap(json.decode(source));

  // Cat copyWith({
  //   String? user_id,
  //   String? breed,
  //   String? gender,
  //   String? age,
  //   String? description,
  //   String? id,
  //   List<String>? images,
  // }) {
  //   return Cat(
  //     user_id: user_id ?? this.user_id,
  //     breed: breed ?? this.breed,
  //     gender: gender ?? this.gender,
  //     age: age ?? this.age,
  //     description: description ?? this.description,
  //     id: id ?? this.id,
  //     images: images ?? this.images,
  //   );
  // }
}
