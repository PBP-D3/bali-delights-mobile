import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import '../services/api_service.dart';

class AddChatModal extends StatefulWidget {
  final Function(int storeId) onChatCreated;
  final List<Store> stores;

  const AddChatModal({
    required this.onChatCreated, 
    required this.stores,
    Key? key
  }) : super(key: key);

  @override
  _AddChatModalState createState() => _AddChatModalState();
}

class _AddChatModalState extends State<AddChatModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Store> _filteredStores = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredStores = widget.stores;
  }

  void _filterStores(String query) {
    setState(() {
      _filteredStores = widget.stores.where((store) {
        return store.fields.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _createChat(int storeId) async {
    setState(() => _isLoading = true);
    try {
      final request = context.read<CookieRequest>();
      final result = await ApiService.createChat(request, storeId);
      
      if (result['success']) {
        if (mounted) {
          widget.onChatCreated(storeId);
        }
      }
    } catch (e) {
      print('Error creating chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating chat: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                    onChanged: _filterStores,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredStores.isEmpty
                            ? const Center(child: Text("No stores found."))
                            : ListView.builder(
                                itemCount: _filteredStores.length,
                                itemBuilder: (context, index) {
                                  final store = _filteredStores[index];
                                  return GestureDetector(
                                    onTap: () => _createChat(store.pk),
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
                                              store.fields.getImage(),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(store.fields.name),
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
