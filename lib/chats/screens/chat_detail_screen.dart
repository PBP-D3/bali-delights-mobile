import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/chats/models/message.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../services/api_service.dart';
import 'edit_message_modal.dart';

class ChatDetailScreen extends StatefulWidget {
  final int storeId; // Changed from chatId to storeId
  final String storeName; // Added store name
  final String storeImage; // Added store image

  const ChatDetailScreen(
      {required this.storeId,
      required this.storeName,
      required this.storeImage,
      Key? key})
      : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  bool _loading = true;
  int? _chatId; // Added to store the chat ID

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    setState(() => _loading = true);
    try {
      final request = context.read<CookieRequest>();
      final chatResult =
          await ApiService.getOrCreateChat(request, widget.storeId);

      if (chatResult['success']) {
        final currentUserId = chatResult['user']?['id'];
        setState(() {
          _chatId = chatResult['chat_id'];
          if (chatResult['messages'] != null) {
            loadMessages();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing chat: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> loadMessages() async {
    if (_chatId == null) return;

    try {
      final request = context.read<CookieRequest>();
      final response = await ApiService.fetchMessages(request, _chatId!);

      if (mounted && response['messages'] != null) {
        final currentUserId = response['user']?['id'];
        final List<dynamic> messagesJson = response['messages'];
        setState(() {
          _messages = messagesJson
              .map((msg) => Message.fromJson(msg, currentUserId))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> sendMessage() async {
    if (_chatId == null) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final request = context.read<CookieRequest>();
    try {
      final success = await ApiService.sendMessage(request, _chatId!, text);
      if (success) {
        _controller.clear();
        await loadMessages(); // Use await here
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  void showEditModal(int messageId, String currentContent) {
    showDialog(
      context: context,
      builder: (ctx) => EditMessageModal(
        messageId: messageId,
        initialContent: currentContent,
        onSave: (updatedContent) async {
          final request = context.read<CookieRequest>();
          try {
            final success = await ApiService.editMessage(
              request,
              messageId,
              updatedContent,
            );
            if (success && mounted) {
              Navigator.pop(ctx); // Only close the modal
              loadMessages(); // Refresh messages
            }
          } catch (e) {
            debugPrint('Error editing message: $e');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C5D2D),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text("Back",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          widget.storeImage,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.storeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48),
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
                          final senderIsUser = msg.senderIsUser;
                          return GestureDetector(
                            onLongPress: () =>
                                showEditModal(msg.id, msg.content),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: senderIsUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7),
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
                                    color: senderIsUser
                                        ? Colors.white
                                        : Colors.grey[800],
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
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
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 20),
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
