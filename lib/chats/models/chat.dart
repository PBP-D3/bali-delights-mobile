import 'message.dart';

class Chat {
  final int id;
  final int sender;
  final String senderUsername;
  final int store;
  final String storeName;
  final String createdAt;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.sender,
    required this.senderUsername,
    required this.store,
    required this.storeName,
    required this.createdAt,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    List messagesJson = json['messages'] ?? [];
    List<Message> msgList = messagesJson.map((m) => Message.fromJson(m)).toList();

    return Chat(
      id: json['id'],
      sender: json['sender'],
      senderUsername: json['sender_username'],
      store: json['store'],
      storeName: json['store_name'],
      createdAt: json['created_at'],
      messages: msgList,
    );
  }
}
