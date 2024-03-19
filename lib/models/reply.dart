import 'dart:convert';

class Reply {
  final String message;
  final String repliedAt;

  Reply({
    required this.message,
    required this.repliedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'repliedAt': repliedAt,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      message: map['message'] ?? '',
      repliedAt: map['repliedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) => Reply.fromMap(json.decode(source));
}
