import 'dart:convert';

class User {
  String id;
  String username;
  String email;
  String token;
  String password;
  String type;
  String imagesP;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
    required this.type,
    required this.imagesP,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      imagesP: map['imagesP'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'token': token,
      'password': password,
      'type': type,
      'imagesP': imagesP,
    };
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
