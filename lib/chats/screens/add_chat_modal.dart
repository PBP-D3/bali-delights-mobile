import 'package:flutter/material.dart';
import '../../api_service.dart'; // Pastikan path ke ApiService benar

class AddChatModal extends StatefulWidget {
  final Function(int storeId) onChatCreated;

  const AddChatModal({required this.onChatCreated, Key? key}) : super(key: key);

  @override
  _AddChatModalState createState() => _AddChatModalState();
}

class _AddChatModalState extends State<AddChatModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores([String? searchQuery]) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stores = await ApiService.fetchStores(searchQuery: searchQuery);
      setState(() {
        _stores = stores;
      });
    } catch (e) {
      debugPrint('Error fetching stores: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: 400,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Start a Chat!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: "Search stores",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _fetchStores(val),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          height: 200,
                          child: _stores.isEmpty
                              ? const Center(child: Text("No stores found."))
                              : ListView.builder(
                                  itemCount: _stores.length,
                                  itemBuilder: (context, index) {
                                    final store = _stores[index];
                                    return GestureDetector(
                                      onTap: () {
                                        widget.onChatCreated(store["id"]);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                store['photo_url'] ?? '',
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(store["name"]),
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
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC6AC8F),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "✕",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
