import 'message.dart';

class Chat {
  final int id;
  final int storeId;
  final String storeName;
  final String senderUsername;
  final Map<String, dynamic>? lastMessage; // Changed to match Django response
  final String storePhotoUrl;

  Chat({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.senderUsername,
    required this.lastMessage,
    required this.storePhotoUrl,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final store = json['store'] ?? {};
    return Chat(
      id: json['id'],
      storeId: store['id'] ?? 0,
      storeName: store['name'] ?? '',
      senderUsername: json['sender']?['username'] ?? '',
      lastMessage: json['last_message'], // Direct from Django response
      storePhotoUrl: store['photo_url'] ?? '',
    );
  }

  String getLastMessagePreview() {
    if (lastMessage == null) return "No messages yet";
    return "last message: ${lastMessage!['content'] ?? 'No content'}";
  }
}
