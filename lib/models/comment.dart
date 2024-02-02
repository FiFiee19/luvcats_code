import 'dart:convert';

import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';

class Comment {
  User? user;
  Commu? post_id;
  final String user_id;
  final String? id;
  final String message;
  final String? createdAt;

  Comment({
    this.user,
    required this.user_id,
    this.post_id,
    this.id,
    required this.message,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'post_id': post_id?.toMap(),
      'message': message,
      'user_id': user_id,
      'id': id,
      'createdAt': createdAt,
    };
  }

  factory Comment.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Comment(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      post_id: map['post_id'] != null ? Commu.fromMap(map['post_id']) : null,
      message: map['message'] ?? '',
      user_id: map['user_id'] ?? '',
      id: map['_id'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));
}
