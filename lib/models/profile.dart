import 'dart:convert';

class Profile {
  final String id;
  final String user_id;
  final String description;
  final String images;
  Profile({
    required this.id,
    required this.user_id,
    required this.description,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'description': description,
      'images': images,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['_id'] ?? '',
      description: map['description'] ?? '',
      user_id: map['user_id'] ?? '',
      images: map['images'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));
}
