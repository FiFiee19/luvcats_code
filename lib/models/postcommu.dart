import 'dart:convert';

import 'package:luvcats_app/models/user.dart';

class Commu {
  User? user;
  final String user_id;
  final String title;
  final String description;
  final String? id;
  final likes;
  final comments;
  final List<String> images;
  final String? createdAt;

  Commu({
    this.user,
    required this.user_id,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    this.id,
    required this.images,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'user_id': user_id,
      'title': title,
      'description': description,
      'id': id,
      'likes': likes,
      'comments': comments,
      'images': images,
      'createdAt': createdAt,
    };
  }

  factory Commu.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    try {
      User? user;
      if (map['user'] is Map<String, dynamic>) {
        user = User.fromMap(map['user']);
      } else if (map['user'] is String) {
        user = null;
      }

      return Commu(
        user: user,
        user_id: map['user_id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        id: map['_id'], 
        likes: map['likes'] ?? [],
        comments: map['comments'] ?? [],
        images: List<String>.from(map['images'] ?? []),
        createdAt: map['createdAt'],
      );
    } catch (error) {
      throw Exception('Error creating Commu object: $error');
    }
  }

  String toJson() => json.encode(toMap());

  factory Commu.fromJson(String source) => Commu.fromMap(json.decode(source));
}
