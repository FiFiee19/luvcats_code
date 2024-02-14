import 'dart:convert';

class Entrepreneur {
  final String id;
  final String user_id;
  final String store_id;
  final String name;
  final String store_address;
  final String phone;
  Entrepreneur({
    required this.id,
    required this.user_id,
    required this.store_id,
    required this.name,
    required this.store_address,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'store_id': store_id,
      'name': name,
      'store_address': store_address,
      'phone': phone,
    };
  }

  factory Entrepreneur.fromMap(Map<String, dynamic> map) {
    return Entrepreneur(
      id: map['_id'] ?? '',
      user_id: map['user_id'] ?? '',
      store_id: map['store_id'] ?? '',
      name: map['name']?? '',
      store_address: map['store_address']?? '',
      phone: map['phone']?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Entrepreneur.fromJson(String source) =>
      Entrepreneur.fromMap(json.decode(source));
}
