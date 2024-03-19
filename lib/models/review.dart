import 'dart:convert';

import 'package:luvcats_app/models/reply.dart';
import 'package:luvcats_app/models/user.dart';

class Review {
  User? user;
  final String cathotelId;
  final String user_id;
  final String? id;
  final String message;
  final double rating;
  final String? createdAt;
  Reply? reply; // Add a reply property

  Review({
    this.user,
    required this.user_id,
    required this.cathotelId,
    this.id,
    required this.message,
    required this.rating,
    this.createdAt,
    this.reply, // Initialize in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'cathotelId': cathotelId,
      'user_id': user_id,
      'id': id,
      'message': message,
      'rating': rating,
      'createdAt': createdAt,
      'reply': reply?.toMap(), // Serialize reply if it's not null
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      user_id: map['user_id'] ?? '',
      cathotelId: map['cathotelId'] ?? '',
      id: map['_id'],
      message: map['message'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      createdAt: map['createdAt'],
      reply: map['reply'] != null
          ? Reply.fromMap(map['reply'])
          : null, // Construct a Reply object if it exists
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}
