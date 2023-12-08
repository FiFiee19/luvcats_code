import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String password;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source));

  // User copyWith({
  //   String? id,
  //   String? username,
  //   String? email,
  //   String? token,
  //   String? password,
  //   String? images,
  // }) {
  //   return User(
  //     id: id ?? this.id,
  //     username: username ?? this.username,
  //     email: email ?? this.email,
  //     password: password ?? this.password,
  //     token: token ?? this.token,
  //     images: images ?? this.images,
  //   );
  // }
}
