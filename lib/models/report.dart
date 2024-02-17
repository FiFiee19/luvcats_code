import 'dart:convert';

import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/models/user.dart';

class Report {
  User? user;
  final String user_id;
  Commu? commu;
  final String message;
  final String? id;

  Report({
    this.user,
    required this.user_id,
    this.commu,
    required this.message,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'user_id': user_id,
      'commu': commu,
      'message': message,
      'id': id,
    };
  }

  factory Report.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Report(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      user_id: map['user_id'] ?? '',
      commu: map['commu'] != null ? Commu.fromMap(map['commu']) : null,
      message: map['message'] ?? '',
      id: map['_id'], // Assuming '_id' is the correct field from your backend
  
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));
}
