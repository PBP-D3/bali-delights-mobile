import 'message.dart';

class Chat {
  final int id;
  final int storeId;
  final String storeName;
  final String senderUsername;
  final String lastMessageTime;
  final String lastMessageContent;
  final String storePhotoUrl;

  Chat({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.senderUsername,
    required this.lastMessageTime,
    required this.lastMessageContent,
    required this.storePhotoUrl,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final store = json['store'] ?? {};
    return Chat(
      id: json['id'],
      storeId: store['id'] ?? 0,
      storeName: store['name'] ?? '',
      senderUsername: json['user']?['username'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      lastMessageContent: json['last_message_content'] ?? '',
      storePhotoUrl: store['photo_url'] ?? '',
    );
  }
}
