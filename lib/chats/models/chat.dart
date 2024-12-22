import 'message.dart';

class Chat {
  final int id;
  final String storeName;
  final String senderUsername;
  final String createdAt;

  Chat({
    required this.id,
    required this.storeName,
    required this.senderUsername,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      storeName: json['store_name'] ?? '',
      senderUsername: json['sender_username'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
