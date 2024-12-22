class Message {
  final int id;
  final String content;
  final String timestamp;
  final int senderId;  // Add senderId
  final bool senderIsUser;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderIsUser,
  });

  factory Message.fromJson(Map<String, dynamic> json, [int? currentUserId]) {
    final senderId = json['sender_id'] ?? 0;
    return Message(
      id: json['id'],
      content: json['content'],
      timestamp: json['timestamp'],
      senderId: senderId,
      senderIsUser: currentUserId != null ? senderId == currentUserId : (json['sender_is_user'] ?? false),
    );
  }
}
