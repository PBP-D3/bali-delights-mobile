import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import '../models/chat.dart';
import 'chat_detail_screen.dart';
import 'delete_chat_modal.dart';
import 'add_chat_modal.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'store_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Chat> _chats = [];
  bool _loading = true;
  List<Store> _stores = [];

  // Simulasi role, ganti sesuai kebutuhan (misalnya: 'shop_owner' atau 'user')
  final String userRole = 'user';

  @override
  void initState() {
    super.initState();
    loadChats();
    fetchStores();
  }

  Future<void> loadChats() async {
    setState(() {
      _loading = true;
    });

    final request = context.watch<CookieRequest>();
    try {
      // Using the correct endpoint from urls.py
      final response = await request.get('${Constants.baseUrl}/chats/');
      
      if (response is List) {
        setState(() {
          _chats = response.map((json) => Chat.fromJson(json)).toList();
        });
      } else {
        debugPrint('Unexpected response format');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading chats: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> fetchStores() async {
    final request = context.watch<CookieRequest>();
    try {
      final response = await request.get('${Constants.baseUrl}/stores/json/');
      List<Store> stores = [];
      for (var item in response) {
        if (item != null) {
          stores.add(Store.fromJson(item));
        }
      }
      setState(() {
        _stores = stores;
      });
    } catch (e) {
      debugPrint('Error fetching stores: $e');
    }
  }

  void openAddChatModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AddChatModal(
          stores: _stores,
          onChatCreated: (storeId) {
            loadChats();
          },
        );
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

  void navigateToStoreDetail(int storeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoreDetailScreen(storeId: storeId),
      ),
    );
  }

  void navigateToChat(int storeId) async {
    final request = context.read<CookieRequest>();
    try {
      // Using create_chat endpoint from urls.py
      final response = await request.post(
        '${Constants.baseUrl}/chats/api/chats/create/',
        {'store_id': storeId.toString()}
      );

      if (response['success'] && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(chatId: response['chat_id']),
          ),
        ).then((_) => loadChats()); // Refresh chat list after returning
      }
    } catch (e) {
      debugPrint('Error creating chat: $e');
    }
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
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
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
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToStoreDetail(1),
                                            child: ClipRRect(
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
                                              "Last message at ${chat.lastMessageTime}",
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
