class Message {
  final int id;
  final int chat;
  final int sender;
  final String senderUsername;
  final String content;
  final String timestamp;

  Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.senderUsername,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chat: json['chat'],
      sender: json['sender'],
      senderUsername: json['sender_username'],
      content: json['content'],
      timestamp: json['timestamp'],
    );
  }
}
