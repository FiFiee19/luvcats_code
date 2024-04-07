import 'dart:convert';
import 'package:luvcats_app/models/user.dart';

class Expense {
  User? user;
  final String user_id;
  final String category;
  final String description;
  final double amount;
  final String? id;
  final String? createdAt;

  Expense({
    this.user,
    required this.user_id,
    required this.category,
    required this.description,
    required this.amount,
    this.id,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'user_id': user_id,
      'category': category,
      'description': description,
      'id': id,
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  factory Expense.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map cannot be null');
    }
    return Expense(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      user_id: map['user_id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      id: map['_id'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source));
}
