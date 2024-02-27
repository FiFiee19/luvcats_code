import 'dart:convert';

import 'package:luvcats_app/models/cathotel.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';



class Review {
  User? user;
  final String cathotelId;
  final String user_id;
  final String? id;
  final String message;
  final double rating;
  final String? createdAt;


  Review({
   this.user,
    required this.user_id,
    required this.cathotelId,
    this.id,
    required this.message,
    required this.rating,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'cathotelId': cathotelId,
      'message': message,
      'rating': rating,
      'user_id': user_id,
      'id': id,
      'createdAt': createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Review(
     user: map['user'] != null ? User.fromMap(map['user']) : null,
    cathotelId: map['cathotelId'] ?? '',
    message: map['message'] ?? '',
    rating: map['rating']?.toDouble() ?? 0.0,
    user_id: map['user_id'] ?? '',
    id: map['_id'],
    createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source));
}
