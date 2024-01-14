import 'dart:convert';

class User {
  String id;
  String username;
  String email;
  String token;
  String password;
  String type;
  String images;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
    required this.type,
    required this.images,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '', // Ensure token is handled here
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      images: map['images'] ?? '',
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
      'images': images,
    };
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
