class Message {
  final int id;
  final String content;
  final String timestamp;
  final int senderId; // Add senderId
  final bool senderIsUser;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderIsUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      timestamp: json['timestamp'],
      senderId: json['sender_id'] ?? 0,
      senderIsUser: json['sender_id'].toString() ==
          json['user_id'].toString(), // Compare sender_id with user_id
    );
  }
}
