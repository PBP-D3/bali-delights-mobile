import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../models/chat.dart';
import 'chat_detail_screen.dart';
import 'delete_chat_modal.dart';
import 'add_chat_modal.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Chat> _chats = [];
  bool _loading = true;

  // Simulasi role, ganti sesuai kebutuhan (misalnya: 'shop_owner' atau 'user')
  final String userRole = 'user';

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    setState(() {
      _loading = true;
    });

    try {
      final chats = await ApiService.fetchChats();
      setState(() {
        _chats = chats;
      });
    } catch (e) {
      debugPrint('Error loading chats: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void openAddChatModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AddChatModal(onChatCreated: (storeId) {
          // Setelah chat dibuat, refresh daftar chat
          loadChats();
        });
      },
    );
  }

  void showDeleteOption(int chatId) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteChatModal(
        chatId: chatId,
        onDeleteSuccess: () {
          Navigator.pop(context);
          loadChats();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Messages'),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            margin: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Messages",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (userRole != "shop_owner")
                      Row(
                        children: [
                          const Text("New Chat",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: openAddChatModal,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC6AC8F),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text("+",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      )
                  ],
                ),

                const SizedBox(height: 16),

                // Search Input
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search messages",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),

                const SizedBox(height: 16),

                // Chat List
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _chats.isEmpty
                          ? Center(
                              child: Text(
                                userRole == "shop_owner"
                                    ? "No chats yet. You will see messages here when customers reach out to you."
                                    : "No chats. Start a chat with your favorite merchant!",
                                style: TextStyle(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _chats.length,
                              itemBuilder: (context, index) {
                                final chat = _chats[index];
                                return GestureDetector(
                                  onLongPress: () => showDeleteOption(chat.id),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChatDetailScreen(chatId: chat.id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (userRole != 'shop_owner')
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              chat.storeName.isNotEmpty
                                                  ? 'https://via.placeholder.com/40'
                                                  : 'https://via.placeholder.com/40',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (userRole != 'shop_owner')
                                          const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userRole == 'shop_owner'
                                                  ? chat.senderUsername
                                                  : chat.storeName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Last message at ${chat.createdAt}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
