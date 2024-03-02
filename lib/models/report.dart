import 'dart:convert';

import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';

class Report {
  User? user;
  final String user_id;
  Commu? commu_id;
  final String message;
  final String? id;

  Report({
    this.user,
    required this.user_id,
    this.commu_id,
    required this.message,
    this.id,
  });

  factory Report.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Report(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      user_id: map['user_id'] ?? '',
      commu_id: map['commu_id'] != null ? Commu.fromMap(map['commu_id']) : null,
      message: map['message'] ?? '',
      id: map['_id'], // Assuming '_id' is the correct field from your backend
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'user_id': user_id,
      'commu_id': commu_id?.toMap(), // Assuming commu has a toMap() method
      'message': message,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));
}