import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/store/model/store.dart';

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
                    child: _filteredStores.isEmpty
                        ? const Center(child: Text("No stores found."))
                        : ListView.builder(
                            itemCount: _filteredStores.length,
                            itemBuilder: (context, index) {
                              final store = _filteredStores[index];
                              return GestureDetector(
                                onTap: () {
                                  widget.onChatCreated(store.pk);
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
