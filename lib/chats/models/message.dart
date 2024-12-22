class Message {
  final int id;
  final String content;
  final String timestamp;
  final bool senderIsUser;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderIsUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      timestamp: json['timestamp'],
      senderIsUser: json['sender_is_user'] ?? false,
    );
  }
}
