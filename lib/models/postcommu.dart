import 'dart:convert';

class Commu {
  final String user_id;
  final String title;
  final String description;
  final String? id;
  final List<String> images;

  Commu({
    required this.user_id,
    required this.title,
    required this.description,
    this.id,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'title': title,
      'description': description,
      'id': id,
      'images': images,
    };
  }

  factory Commu.fromMap(Map<String, dynamic>? map) {
    return Commu(
      user_id: map?['user_id'] ?? '',
      title: map?['title'] ?? '',
      description: map?['description'] ?? '',
      id: map?['_id'], // แก้จาก 'id' เป็น '_id'
      images: List<String>.from(map?['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Commu.fromJson(String source) => Commu.fromMap(json.decode(source));

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
