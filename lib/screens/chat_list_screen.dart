import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/chat.dart';
import 'chat_detail_screen.dart';
import 'delete_chat_modal.dart';
import 'add_chat_modal.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> _chats = [];
  bool _loading = true;
  TextEditingController _searchController = TextEditingController();

  // Simulasi role, ganti sesuai kebutuhan (misalnya: 'shop_owner' atau 'user')
  String userRole = 'user'; 

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      final chats = await ApiService.fetchChats();
      setState(() {
        _chats = chats;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error loading chats: $e');
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
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          // Mirip max-w-4xl: kita batasi lebar konten agar tidak terlalu melebar
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            margin: EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 48, horizontal: 16),
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
                          Text("New Chat", style: TextStyle(color: Colors.black, fontSize: 16)),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: openAddChatModal,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFC6AC8F), // secondary
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text("+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      )
                  ],
                ),

                SizedBox(height: 16),

                // Search Input
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search messages",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),

                SizedBox(height: 16),

                // Chat List
                Expanded(
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
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
                                  onLongPress: () {
                                    // Tiru right-click: gunakan long press untuk memunculkan modal delete
                                    showDeleteOption(chat.id);
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatDetailScreen(chatId: chat.id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        if (userRole != 'shop_owner')
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.network(
                                              'https://via.placeholder.com/40', // Ganti dengan chat.store.photo_url jika tersedia
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (userRole != 'shop_owner') SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userRole == 'shop_owner' ? "CustomerUsername" : chat.storeName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              userRole == "shop_owner"
                                                  ? "Message from Customer at ${chat.createdAt}"
                                                  : "Last message at ${chat.createdAt}",
                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
