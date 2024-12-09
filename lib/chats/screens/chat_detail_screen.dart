import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../models/message.dart';
import 'edit_message_modal.dart';

class ChatDetailScreen extends StatefulWidget {
  final int chatId;

  ChatDetailScreen({required this.chatId});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<Message> _messages = [];
  bool _loading = true;
  TextEditingController _controller = TextEditingController();
  int? currentMessageId;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final msgs = await ApiService.fetchMessages(widget.chatId);
      setState(() {
        _messages = msgs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error loading messages: $e');
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final success = await ApiService.sendMessage(widget.chatId, text);
    if (success) {
      _controller.clear();
      loadMessages();
    } else {
      print('Failed to send message');
    }
  }

  void showEditModal(int messageId, String currentContent) {
    showDialog(
      context: context,
      builder: (ctx) => EditMessageModal(
        initialContent: currentContent,
        onSave: (updatedContent) async {
          // Panggil endpoint edit message di sini
          // Karena kita belum buat endpoint edit disini, asumsikan sukses
          // Untuk implementasi sebenarnya, gunakan ApiService serupa sendMessage.
          // Setelah sukses, refresh messages:
          // await ApiService.editMessage(messageId, updatedContent);
          Navigator.pop(ctx);
          loadMessages();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Beberapa variabel tiruan untuk meniru template:
    String storeName = "StoreName"; // Ganti dengan data store sebenarnya
    String? custName = null; // Jika null, pakai storeName

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header mirip chat_personal.html
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF8C5D2D), // amber-800
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          'https://via.placeholder.com/40', // store image placeholder
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        custName ?? storeName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  SizedBox(width: 48), // spacing dummy, sesuai template
                ],
              ),
            ),

            // Message List
            Expanded(
              child: Container(
                color: Color(0xFFf3f3f3), // bg-gray-100
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          bool senderIsUser = true; // Atur sesuai logic auth
                          return GestureDetector(
                            onLongPress: () {
                              // Edit message modal
                              showEditModal(msg.id, msg.content);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              alignment: senderIsUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: senderIsUser ? Color(0xFFC6AC8F) : Color(0xFFEAE0D5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  msg.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: senderIsUser ? Colors.white : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Input message form
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFC6AC8F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
