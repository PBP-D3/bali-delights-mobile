import 'dart:async';
import 'package:flutter/material.dart';
import '../../api_service.dart'; // Pastikan path ke ApiService benar
import '../../models/message.dart';
import 'edit_message_modal.dart';

class ChatDetailScreen extends StatefulWidget {
  final int chatId;

  const ChatDetailScreen({required this.chatId, Key? key}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    setState(() {
      _loading = true;
    });
    try {
      final msgs = await ApiService.fetchMessages(widget.chatId);
      setState(() {
        _messages = msgs;
      });
    } catch (e) {
      debugPrint('Error loading messages: $e');
    } finally {
      setState(() {
        _loading = false;
      });
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
      debugPrint('Failed to send message');
    }
  }

  void showEditModal(int messageId, String currentContent) {
    showDialog(
      context: context,
      builder: (ctx) => EditMessageModal(
        messageId: messageId, // Tambahkan messageId
        initialContent: currentContent,
        onSave: (updatedContent) async {
          final success = await ApiService.editMessage(messageId, updatedContent);
          if (success) {
            Navigator.pop(ctx);
            loadMessages();
          } else {
            debugPrint('Failed to edit message');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const storeName = "StoreName"; // Ganti dengan nama toko yang sebenarnya
    const custName = null; // Ubah dengan nama customer jika ada

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C5D2D), // amber-800
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
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
                          'https://via.placeholder.com/40', // Ganti dengan URL gambar toko
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        custName ?? storeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48), // Dummy spacing
                ],
              ),
            ),

            // Message List
            Expanded(
              child: Container(
                color: const Color(0xFFf3f3f3), // bg-gray-100
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          const senderIsUser = true; // Atur sesuai logika autentikasi
                          return GestureDetector(
                            onLongPress: () => showEditModal(msg.id, msg.content),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: senderIsUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: senderIsUser
                                      ? const Color(0xFFC6AC8F)
                                      : const Color(0xFFEAE0D5),
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

            // Input Message Form
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC6AC8F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
